% recenter_wWaffle.m
%
%
%
% Jorge Llop - Nov 17, 2019

tint = 1e-4;
hcst_andor_setExposureTime(bench,tint);

peakPSF = 1;%bench.info.PSFpeaks(end)/mp.peakPSFtint*bench.andor.tint*mp.NDfilter_cal;
frameSize = double(bench.andor.AOIWidth);

% Flatten DM
hcst_DM_flattenDM(bench, true );% sets the DM to flatvec

vortexPos = [bench.FPM.VORTEX_V0, bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];
resPos = hcst_FPM_move(bench,vortexPos);
rawC_4cal = (hcst_andor_getImage(bench) )/peakPSF;

cropsize = double(bench.andor.AOIHeight);
[X,Y] = meshgrid(-cropsize/2:cropsize/2-1,-cropsize/2:cropsize/2-1);
[THETA,RHO] = cart2pol(X,Y);
THETA = THETA+pi;
maskcenter = ones(cropsize);
maskcenter(RHO<10) = 0;
maskQuad1 = and(THETA >= 0, THETA <= pi/2);
maskQuad2 = and(THETA >= pi/2, THETA <= 2*pi/2);
maskQuad3 = and(THETA >= pi, THETA <= 3*pi/2);
maskQuad4 = and(THETA >= 3*pi/2, THETA <= pi*2);

lamOverD = bench.andor.pixelPerLamOverD;% Pixels per lambda/D
wfl_ang = 45;
PTV4cal = 0.04;% Waffle peak to valley
contr_guess = 2e-6;% Guess of contrast for speckle
numPixperCycle =  bench.andor.numPixperCycle;

spatFreqs2Scan = 9:0.25:14;

Ical = [];
lamOverDCal = [];
x_offsets = [];
y_offsets = [];
angDMs = [];
for wfl_spatFreq = spatFreqs2Scan

    cmds = hcst_DM_applyWaffle( bench, wfl_spatFreq, wfl_ang, PTV4cal);

    im1 = hcst_andor_getImage(bench) ;
    rawC = im1/peakPSF;
    diffRawC = (rawC-rawC_4cal).*maskcenter;
    contr_guess = max(max(diffRawC));% Guess of contrast for speckle

    figure(4);
%         imagesc(xvals/lamOverD,yvals/lamOverD,rawC-rawC_4cal);
    imagesc(diffRawC);
    axis image; 
    colorbar;%caxis([0 1e-4]);
    title('difference image with waffle')
    xlabel('$x/\lambda F^{\#}$','Interpreter','latex');
    ylabel('$y/\lambda F^{\#}$','Interpreter','latex');
    grid on;set(gca,'gridcolor','w');
    drawnow;

    quadIm = diffRawC.*maskQuad1;
    [~,ind_ma] = max(quadIm(:));
    [ind1_x,ind1_y] = ind2sub([cropsize,cropsize],ind_ma);
    quadIm = diffRawC.*maskQuad2;
    [~,ind_ma] = max(quadIm(:));
    [ind2_x,ind2_y] = ind2sub([cropsize,cropsize],ind_ma);
    quadIm = diffRawC.*maskQuad3;
    [~,ind_ma] = max(quadIm(:));
    [ind3_x,ind3_y] = ind2sub([cropsize,cropsize],ind_ma);
    quadIm = diffRawC.*maskQuad4;
    [~,ind_ma] = max(quadIm(:));
    [ind4_x,ind4_y] = ind2sub([cropsize,cropsize],ind_ma);
    x_offset = mean([ind1_x,ind2_x,ind3_x,ind4_x]-cropsize/2-1);
    y_offset = mean([ind1_y,ind2_y,ind3_y,ind4_y]-cropsize/2-1);
    x_offsets = [x_offsets,x_offset];
    y_offsets = [y_offsets,y_offset];


%     [x1,x2,x3,x4,fits] = gaussFitWaffle(diffRawC,wfl_spatFreq,45*pi/180,contr_guess,numPixperCycle,lamOverD);
% 
%     xposs = [x1(2) x2(2) x3(2) x4(2)];
%     yposs = [x1(4) x2(4) x3(4) x4(4)];
%     x_offset = mean(xposs);
%     y_offset = mean(yposs);
%     x_offsets = [x_offsets,x_offset];
%     y_offsets = [y_offsets,y_offset];
%     lamOverD_empr = mean(sqrt((xposs-x_offset).^2+(yposs-y_offset).^2))/wfl_spatFreq;
% 
%     figure(5);
% %         imagesc(xvals/lamOverD,yvals/lamOverD,fits);
%     imagesc(fits);
%     axis image; 
%     colorbar;%caxis([0 1e-4]);
%     title('gaussian fits')
%     xlabel('$x/\lambda F^{\#}$','Interpreter','latex');
%     ylabel('$y/\lambda F^{\#}$','Interpreter','latex');
%     grid on;set(gca,'gridcolor','w');
%     drawnow;


    %Ical = [Ical,mean(rawC(Qspec))-mean(rawC_init(Qspec))];
%     lamOverDCal = [lamOverDCal,lamOverD_empr];
end

x_offset = median(x_offsets);
y_offset = median(y_offsets);
disp(['x_offset: ',num2str(x_offset)])
disp(['y_offset: ',num2str(y_offset)])
%% Accept result
if abs(x_offset)>1 || abs(y_offset)>1
    if abs(x_offset)<1
        x_offset = 0;
    end
    if abs(y_offset)<1
        y_offset = 0;
    end
    centcol = bench.andor.FocusCol + y_offset;
    centrow = bench.andor.FocusRow + x_offset;

    hcst_andor_setSubwindow(bench,centrow,centcol,frameSize);
    bench.andor.FocusCol = bench.andor.FocusCol + y_offset;
    bench.andor.FocusRow = bench.andor.FocusRow + x_offset;
end
% Flatten DM
hcst_DM_flattenDM(bench, true );% sets the DM to flatvec
