% hcst_rotStagesAutoCrossPol.m
%
%
%
% Jorge Llop - Oct 10, 2019

if(~exist('bench','var'))
	bench = hcst_config();
end

if(~bench.andor.CONNECTED)
	hcst_setUpAndor(bench,false);
end

if(~bench.FPM.CONNECTED)
    hcst_setUpFPM(bench);
end

if(~bench.LPQWP.CONNECTED)
    hcst_setUpLPQWP(bench);
end
%%
% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

tint = 1e-1;

hcst_andor_setExposureTime(bench,tint);

centrow = bench.andor.FocusRow;
centcol = bench.andor.FocusCol;
cropsize = 128;
hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);

dark0 = 0;

numRot = 25;
% midLP = 143.2;
% midQWP = 79.05;
% delta_ang = 0.25;
% rot_arrLP = linspace(midLP-delta_ang,midLP+delta_ang,numRot);
% rot_arrQWP = linspace(midQWP-delta_ang,midQWP+delta_ang,numRot);
rot_arrLP = linspace(0,339,numRot);
rot_arrQWP = linspace(0,339,numRot);
peak_arr = zeros(numRot);
for II=1:numRot
    rotLP = rot_arrLP(II);
    for JJ=1:numRot
        rotQWP = rot_arrQWP(JJ);
        pos = hcst_LPQWP_move(bench,[nan,rotQWP,rotLP,nan]);
        im0 = hcst_andor_getImage(bench) - dark0;
        peak = max(im0(:));

        figure(112);
        imagesc(log10_4plot(im0/2^16));
        axis image; 
        colorbar;%caxis([-4 0]);
        title([num2str(II),' - ',num2str(JJ)],'FontSize',32)
    %     text(10,10,num2str(peak_rel),'Color','w','FontSize',32);
        text(10,3,num2str(peak),'Color','w','FontSize',32);
        drawnow;
        peak_arr(II,JJ) = peak;
    end
end
% %% Figure
figure(333)
imagesc(rot_arrQWP,rot_arrLP,peak_arr)
axis image;
xlabel('Rot LP2 [deg]')
ylabel('Rot QWP2 [deg]')
% % Search min
% [~,ind_mi] = 
%% Accept result
rotLP = 143.3;
rotQWP = 79.05;
pos = hcst_LPQWP_move(bench,[rotLP,rotQWP]);
bench.LPQWP.posLP = rotLP;
bench.LPQWP.posQWP = rotQWP;

%%
hcst_disconnectDevices(bench, false, false)
