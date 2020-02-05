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

tint_arr = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1.5,2,3,5];
numtint = numel(tint_arr2);

indtint = 1;

hcst_andor_setExposureTime(bench,tint);

centrow = bench.andor.FocusRow;
centcol = bench.andor.FocusCol;
cropsize = 128;
hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);

dark0 = 0;

numRot = 100;
midLP = 56.5;
midQWP = 155.4;
delta_ang = 25;
rot_arrLP = linspace(midLP-delta_ang,midLP+delta_ang,numRot);
rot_arrQWP = linspace(midQWP-delta_ang,midQWP+delta_ang,numRot);
% rot_arrLP = linspace(0,339,numRot);
% rot_arrQWP = linspace(0,339,numRot);
peak_mat = zeros(numRot)*nan;
for II=1:numRot
    rotLP = rot_arrLP(II);
    count = 1;
    while 1
        tint = tint_arr2(indtint);
        hcst_andor_setExposureTime(bench,tint);
        
        rotQWP = rot_arrQWP(count);
        pos = hcst_LPQWP_move(bench,[nan,rotQWP,rotLP,nan]);
        im0 = hcst_andor_getImage(bench) - dark0;
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         im0 = im0 - median(im0(:));
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        peak = max(im0(:));

        figure(112);
        imagesc(log10_4plot(im0/2^16));
        axis image; 
        colorbar;%caxis([-4 0]);
        title([num2str(II),' - ',num2str(count)],'FontSize',32)
    %     text(10,10,num2str(peak_rel),'Color','w','FontSize',32);
        text(10,3,num2str(peak),'Color','w','FontSize',32);
        drawnow;
        if peak>60e3
            if indtint>1
                indtint = indtint-1;
            end
            disp('Exposure too high!')
        elseif peak<500
            if indtint<numtint
                indtint = indtint+1;
            end
            disp('Exposure too low!')
        else
            peak_mat(II,count) = peak/tint;
            count = count+1;
        end
        figure(202)
        imagesc(rot_arrQWP,rot_arrLP,peak_mat/ma_peak)
        axis image;
        xlabel('Rot QWP1 [deg]')
        ylabel('Rot LP2 [deg]')
        colorbar
        drawnow
        if count>numRot; break; end
    end
end
% %% Figure

ma = max(peak_mat(:));
peak_norm_mat = peak_mat/ma_peak;
figure(333)
imagesc(rot_arrQWP,rot_arrLP,peak_norm_mat)
axis image;
xlabel('Rot QWP1 [deg]')
ylabel('Rot LP2 [deg]')
title('Extinction Ratio')
colorbar

%%
[mi,ind_mi] = min(peak_mat(:)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
[ind_x,ind_y] = ind2sub(size(peak_mat),ind_mi);
disp(['LP2 rot: ', num2str(rot_arrLP(ind_x)),' QWP1 rot: ', num2str(rot_arrQWP(ind_y))])

%% Save result
% fitswrite(peak_mat,'test_peak_mat2.fits')
save('2DSearch_QWP2Out_fineSearch_Nov01.mat','peak_mat','ma_peak','rot_arrQWP','rot_arrLP');
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
