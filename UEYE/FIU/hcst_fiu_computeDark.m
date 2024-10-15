% hcst_fiu_computeDark
%
% Move fpm, fiu, to compute new dark or background for the highest gain
% setting
%
% Jorge Llop - Jul 28, 2020

%% In case you don't have access to shut down the laser

if nkt
    tb_NKT_setEmission(bench,false)
    pause(2)
else
    vortexPos = [bench.FPM.VORTEX_V0, bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];
    resPos = hcst_FPM_move(bench,vortexPos);

    fiupos = [bench.FIUstages.CENTER_H0, ...
        bench.FIUstages.CENTER_F0, ...
        bench.FIUstages.CENTER_V0];
    hcst_PIStage_move(bench, -fiupos);
end

G = hcst_setFemtoGain(bench,11);
G = hcst_setFemtoGain(bench,11);
pause(bench.Femto.waitTimeAfterGainChange)

numtry = 50000;
V_arr = zeros(numtry,1);
for JJ=1:numtry
    V_arr(JJ) = hcst_readFemtoOutput_avgd(bench,1);
end
bench.Femto.V_offset(end) = mean(V_arr);
bench.Femto.noise_arr(end) = std(V_arr);
disp(['Measured the V Offset: ',num2str(bench.Femto.V_offset(end))])
disp(['Measured the V Offset: ',num2str(bench.Femto.noise_arr(end))])

figure(113)
hist(V_arr)
title('Hist V Offset at gain 11')
tb_NKT_setEmission(bench,true)
