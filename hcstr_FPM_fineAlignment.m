function [bench] = hcstr_FPM_fineAlignment(bench,mp,useDH)

if useDH
    mask = mp.Fend.corr.mask;
    tint = bench.andor.tint;
    map = mp.dm1.V'; % There's a transpose between Matlab and BMC indexing
    cmds = hcst_DM_apply2Dmap(bench,map,1);% Returns actual DM commands
else
    mask = 1;
    tint = 1e-1;
    % path2startingMap = [bench.info.HCST_DATA_DIR,'zygo_flat/2019Mar08/'];
%     path2startingMap = [bench.info.HCST_DATA_DIR,'is_results/2019Apr24/'];
%     flatmapFile4SN = getLastMATfile(path2startingMap);
%     load(flatmapFile4SN);% load DM commands to cmds
%     data = cmds;
%     err_code = BMCSendData(bench.DM.dm, data);
%     if(err_code~=0)
%         eString = BMCGetErrorString(err_code);
%         error(eString);
%     end
    hcst_DM_flattenDM(bench, true );% sets the DM to flatvec
end

% cropsize = 128;
% centcol = bench.andor.FocusCol;
% centrow = bench.andor.FocusRow;

hcst_andor_setExposureTime(bench,tint);
% hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);

% bench.FPM.VORTEX_V0 = 1.914;
% bench.FPM.VORTEX_H0 = 5.705;
% bench.FPM.VORTEX_F0 = 3.955;

% bench.FPM.VORTEX_F0 = 3.955;
% vPosList = 0.10:0.01:0.30;
% hPosList = -0.30:0.05:0.0;
% vPosList = -0.001:0.0005:0.001;
vPosList = -0.005:0.0025:0.005;
hPosList = vPosList;
% vPosList = 0;
% vPosList = 5.705;
% hPosList = 3.955;

while true
bestMaxVal = 1e12;
for deltaV = vPosList
    for deltaH = hPosList

        vortexPos = [bench.FPM.VORTEX_V0+deltaV , bench.FPM.VORTEX_H0+deltaH, bench.FPM.VORTEX_F0];

        resPos = hcst_FPM_move(bench,vortexPos);

        dark0 = hcst_andor_loadDark(bench,[bench.info.path2darks,'dark_tint',num2str(tint),'_coadds1.fits']);
        im0 = hcst_andor_getImage(bench) - dark0;
        
        im = im0.*mask;
        maxVal = sum(im(:));
        
        if(maxVal<bestMaxVal)
            bestDeltaV = deltaV;
            bestDeltaH = deltaH;
            bestMaxVal = maxVal;
        end
        
        figure(1);
        imagesc(log10_4plot(im0/2^16));
        axis image; 
        colorbar;caxis([-4 0]);
        title(['V ',num2str(deltaV),' - H ',num2str(deltaH)]);set(gca,'ydir','normal');

    end
end
disp(['bestDeltaV: ',num2str(bestDeltaV)])
disp(['bestDeltaH: ',num2str(bestDeltaH)])
disp(['Sum im: ',num2str(maxVal)])
%% Check new FPM position - Accept result XY


bench.FPM.VORTEX_V0 = bench.FPM.VORTEX_V0 + bestDeltaV;
bench.FPM.VORTEX_H0 = bench.FPM.VORTEX_H0 + bestDeltaH;
vortexPos = [bench.FPM.VORTEX_V0 , bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];

if max([abs(bestDeltaV),abs(bestDeltaH)])<max(abs(vPosList)); break; end
end

resPos = hcst_FPM_move(bench,vortexPos);

end