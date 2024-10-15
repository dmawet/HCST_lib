% hcst_fiu_findSMFwProbe
%
% Search for the SMF with a DM probe
%
% Jorge Llop - Jul 9, 2020

function [ x_smf_out, y_smf_out ] = hcst_fiu_findOffaxisSMFwProbe(bench, mp)

mp4probe = mp;
mp4probe.est.probe.gainFudge = 10;
InormProbe = 1e-10;
phase = 0;

Xloc = mp.est.probe.Xloc;
Yloc = mp.est.probe.Yloc;

delta_angsep_arr = -0.1:0.05:0.1;
num_angsep = numel(delta_angsep_arr);
while true
    out_mat = zeros(num_angsep,num_angsep)*nan;
    bestMaxVal = -1e12;
    count = 0;
    for II = 1:num_angsep
        for JJ = 1:num_angsep
            % Change position
            mp4probe.est.probe.Xloc = Xloc + delta_angsep_arr(II);
            mp4probe.est.probe.Yloc = Yloc + delta_angsep_arr(JJ);

            probeCmd = falco_gen_pairwise_probe_fiber(mp4probe,InormProbe,phase,'m');
            map = (probeCmd./mp.dm1.VtoH)'; % There's a transpose between Matlab and BMC indexing
            cmds = hcst_DM_apply2Dmap(bench,map,1);% Returns actual DM commands 
            
            pause(1)

            V = hcst_readFemtoOutput_adaptive_inV(bench,bench.Femto.averageNumReads);
            out_mat(II,JJ) = V;
            if(V>bestMaxVal) && count~=0
                bestDelta_angsep_x = delta_angsep_arr(II);
                bestDelta_angsep_y = delta_angsep_arr(JJ);
                bestMaxVal = V;
            end
            if count==0; out_mat(1) = nan;end
            figure(221);
            imagesc(out_mat);
            axis image; 
            colorbar;%caxis([-3 -1]);
            title(['X ',num2str(delta_angsep_arr(II)),' - Y ',num2str(delta_angsep_arr(JJ))]);
            set(gca,'ydir','normal');
            set(gca,'FontSize',15)
            drawnow;
            count = count + 1;
        end 
    end
    Xloc = Xloc + bestDelta_angsep_x;
    Yloc = Yloc + bestDelta_angsep_y;
    if max([abs(bestDelta_angsep_x),abs(bestDelta_angsep_y)])<max(abs(delta_angsep_arr)); break; end 
    
end
x_smf_out = Xloc;
y_smf_out = Yloc;

bench.FIUstages.smf_angular_pos_efc1 = [x_smf_out, y_smf_out];
end


