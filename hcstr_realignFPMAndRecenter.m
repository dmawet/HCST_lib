% hcstr_realignFPMAndRecenter.m
%
% to be used during EFC iterations to realign the FPM and recenter the
% subwindow
%
% Jorge Llop - May 08, 2019

function [bench] = hcstr_realignFPMAndRecenter(bench,mp)
    tint0 = bench.andor.tint;
    if true
    tint = 1e-3;
    hcst_andor_setExposureTime(bench,tint);
    
    peakPSF = bench.info.PSFpeaks(end)/mp.peakPSFtint*bench.andor.tint*mp.NDfilter_cal;
    frameSize = double(bench.andor.AOIWidth);
    
    % Flatten DM
    path2startingMap = [bench.info.HCST_DATA_DIR,'zygo_flat/2019Mar08/'];
    % path2startingMap = [bench.info.HCST_DATA_DIR,'is_results/2019Apr18/'];
    flatmapFile4SN = getLastMATfile(path2startingMap);
    load(flatmapFile4SN);% load DM commands to cmds

    data = cmds;
    err_code = BMCSendData(bench.DM.dm, data);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    
    vortexPos = [bench.FPM.VORTEX_V0, bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];
    resPos = hcst_FPM_move(bench,vortexPos);
    rawC_4cal = (hcst_andor_getImage(bench) )/peakPSF;

    lamOverD = bench.andor.pixelPerLamOverD;% Pixels per lambda/D
    wfl_ang = 45;
    PTV4cal = 0.005;% Waffle peak to valley
    contr_guess = 1e-4;% Guess of contrast for speckle
    numPixperCycle =  bench.andor.numPixperCycle;

    spatFreqs2Scan = 4:0.5:10;

    Ical = [];
    lamOverDCal = [];
    x_offsets = [];
    y_offsets = [];
    angDMs = [];
    for wfl_spatFreq = spatFreqs2Scan

        cmds = hcst_DM_applyWaffle( bench, wfl_spatFreq, wfl_ang, PTV4cal);

        im1 = hcst_andor_getImage(bench) ;

        rawC = im1/peakPSF;

        figure(4);
%         imagesc(xvals/lamOverD,yvals/lamOverD,rawC-rawC_4cal);
        imagesc(rawC-rawC_4cal);
        axis image; 
        colorbar;%caxis([0 1e-4]);
        title('difference image with waffle')
        xlabel('$x/\lambda F^{\#}$','Interpreter','latex');
        ylabel('$y/\lambda F^{\#}$','Interpreter','latex');
        grid on;set(gca,'gridcolor','w');
        drawnow;

        [x1,x2,x3,x4,fits] = gaussFitWaffle(rawC-rawC_4cal,wfl_spatFreq,45*pi/180,contr_guess,numPixperCycle,lamOverD);

        xposs = [x1(2) x2(2) x3(2) x4(2)];
        yposs = [x1(4) x2(4) x3(4) x4(4)];
        x_offset = mean(xposs);
        y_offset = mean(yposs);
        x_offsets = [x_offsets,x_offset];
        y_offsets = [y_offsets,y_offset];
        lamOverD_empr = mean(sqrt((xposs-x_offset).^2+(yposs-y_offset).^2))/wfl_spatFreq;

        starPos = [x_offset,y_offset];

        angDM = 180/pi*mean([atan2(x1(4)-y_offset,x1(2)-x_offset),...
                             atan2(x2(4)-y_offset,x2(2)-x_offset)-pi/2,...
                             atan2(x3(4)-y_offset,x3(2)-x_offset)+pi,...
                             atan2(x4(4)-y_offset,x4(2)-x_offset)+pi/2])-45;
        angDMs = [angDMs,angDM];

        figure(5);
%         imagesc(xvals/lamOverD,yvals/lamOverD,fits);
        imagesc(fits);
        axis image; 
    %     colorbar;caxis([0 1e-4]);
        title('gaussian fits')
        xlabel('$x/\lambda F^{\#}$','Interpreter','latex');
        ylabel('$y/\lambda F^{\#}$','Interpreter','latex');
        grid on;set(gca,'gridcolor','w');
        drawnow;

        Qspec = generateSpeckleMask(x3(2),x3(4),lamOverD,frameSize);

        Ical_cur = sum(sum(rawC.*Qspec))/sum(sum(Qspec))-sum(sum(rawC_4cal.*Qspec))/sum(sum(Qspec));
        Ical = [Ical,Ical_cur];

        %Ical = [Ical,mean(rawC(Qspec))-mean(rawC_init(Qspec))];
        lamOverDCal = [lamOverDCal,lamOverD_empr];
    end

    x_offset = median(x_offsets);
    y_offset = median(y_offsets);
    disp(['x_offset: ',num2str(x_offset)])
    disp(['y_offset: ',num2str(y_offset)])
    %% Creat an offset on the centering
    % xoff = 1;
    % yoff = 0;
    xoff = x_offset;
    yoff = y_offset;
    centcol = bench.andor.FocusCol + xoff;
    centrow = bench.andor.FocusRow + yoff;

    hcst_andor_setSubwindow(bench,centrow,centcol,frameSize);
    bench.andor.FocusCol = bench.andor.FocusCol + xoff;
    bench.andor.FocusRow = bench.andor.FocusRow + yoff;
end
    %% Realign FPM
    fprintf(['Fine alignment of FPM' '\n' ]);
     hcst_andor_setExposureTime(bench,tint0);
    [bench] = hcstr_FPM_fineAlignment(bench,mp,false);
     hcst_andor_setExposureTime(bench,tint0);
end
