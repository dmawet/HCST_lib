% hcst_fiu_findSMFwProbe
%
% Search for the SMF with a DM probe
%
% Jorge Llop - Jan 30, 2020

function [ ang_sep, rot ] = hcst_fiu_findSMFwProbe(bench, smf_angsep0,angrot0,gainFemto)

PTV = 0.1;
G = hcst_setFemtoGain(bench,8);
G = hcst_setFemtoGain(bench,8);
pause(bench.Femto.waitTimeAfterGainChange)

delta_angsep_arr = -0.05:0.025:0.05;
num_angsep = numel(delta_angsep_arr);
delta_angrot_arr = -0.25:0.25:0.25;
num_angrot = numel(delta_angrot_arr);
out_mat = zeros(num_angrot,num_angsep)*nan;
bestMaxVal = -1e12;
for II = 1:num_angrot
    for JJ = 1:num_angsep
        [cmds,~] = hcst_DM_applySineList( bench, [smf_angsep0+delta_angsep_arr(JJ)], ...
            [angrot0+delta_angrot_arr(II)], [PTV], [90] );

        V = hcst_readFemtoOutput_avgd(bench,bench.Femto.averageNumReads);
        out_mat(II,JJ) = V;
        if(V>bestMaxVal)
            bestDelta_angrot = delta_angrot_arr(II);
            bestDelta_angsep = delta_angsep_arr(JJ);
            bestMaxVal = V;
        end
        
        figure(221);
        imagesc(out_mat);
        axis image; 
        colorbar;%caxis([-3 -1]);
        title(['Rot ',num2str(delta_angrot_arr(II)),' - Ang Sep ',num2str(delta_angsep_arr(JJ))]);
        set(gca,'ydir','normal');
        set(gca,'FontSize',15)
        drawnow;
    end 
end
ang_sep = smf_angsep0 + bestDelta_angsep;
rot = angrot0 + bestDelta_angrot;
G = hcst_setFemtoGain(bench,gainFemto);
pause(bench.Femto.waitTimeAfterGainChange)

