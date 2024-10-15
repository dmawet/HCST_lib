% hcst_fiu_computeCouplingMap.m
%
%
%
% Jorge Llop - Feb 8, 2020

%% Load plate scale data
load('/home/hcst/HCST_lib/FIU/output/characterizePLateScaleAtSMFplane.mat')

% Compute the desired delta movement of the FIU stages
linfit = polyfit(fiu_pos_x_arr-fiu_pos_H0,wx_arr,1);
delta_ws = 0.2;
delta_fiu_pos = delta_ws/linfit(1);

% Compute the array of movements
delta_pos_max = max(fiu_pos_x_arr-fiu_pos_H0);
wx_arr_max = max(wx_arr);
delta_pos_arr = (-delta_pos_max):delta_fiu_pos:(+delta_pos_max);
wx_fit_arr = delta_pos_arr*linfit(1);
nummov = numel(delta_pos_arr);

% Move FPM
vortexPos = [bench.FPM.VORTEX_V0, bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];
resPos = hcst_FPM_move(bench,vortexPos);

%%
out_mat = zeros(nummov);
for II = 1:nummov
    for JJ = 1:nummov
        fiuPos = [bench.FIUstages.CENTER_H0+delta_pos_arr(II), bench.FIUstages.CENTER_F0, bench.FIUstages.CENTER_V0+delta_pos_arr(JJ)];
        hcst_PIStage_move(bench,fiuPos);

        V = hcst_readFemtoOutput_adaptive(bench,10);
        gain_set = log10(bench.Femto.gain)-4;
        V = V-bench.Femto.noise_offset(gain_set);
        V = V/(bench.Femto.gainStep^gain_set);
        out_mat(II,JJ) = V/bench.Femto.V0_peak;

        % Camera image
%         im0 = hcst_andor_getImage(bench);
%         figure(112);
%         imagesc(log10_4plot(im0/2^16));
%         axis image; 

        figure(221);
        imagesc(out_mat);
        axis image; 
        colorbar;%caxis([-3 -1]);
%         title(['Rot ',num2str(delta_angrot_arr(II)),' - Ang Sep ',num2str(delta_angsep_arr(JJ))]);
        set(gca,'ydir','normal');
        set(gca,'FontSize',15)
        drawnow;
    end 
end
%% Save Data
outDir='/home/hcst/HCST_lib/FIU/output/';
label = 'Feb182020v2';

out_matfin = out_mat;
out_matfin(out_matfin<=0) = nan;
figure(300);
imagesc(wx_fit_arr,wx_fit_arr,out_matfin);
axis image; 
colorbar;%caxis([-3 -1]);
title('Coupling efficiency map');
xlabel('x [lam/D]')
ylabel('y [lam/D]')
set(gca,'ydir','normal');
set(gca,'FontSize',15)
drawnow;
flnm=['fig_couplingMat_linScele_',label,'.png'];
export_fig([outDir,flnm])

figure(301);
imagesc(wx_fit_arr,wx_fit_arr,log10(out_matfin));
axis image; 
colorbar;%caxis([-3 -1]);
title('Coupling efficiency map - Log scale');
xlabel('x [lam/D]')
ylabel('y [lam/D]')
set(gca,'ydir','normal');
set(gca,'FontSize',15)
drawnow;
flnm=['fig_couplingMat_logScele_',label,'.png'];
export_fig([outDir,flnm])

nmfl = ['couplingMap_',label];
coupling_map = out_mat;
save(['/home/hcst/HCST_lib/FIU/output/',nmfl,'.mat'],'coupling_map','wx_fit_arr','delta_pos_arr')

%%

hcst_disconnectDevices(bench, true, false)