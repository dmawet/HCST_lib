% hcst_crossPolarizationStepByStep.m
%
% Cros polarization step by step at HCST
%
% Jorge Llop - Nov 1, 2019

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
%% overall peak for computing extinction ratio
ma_peak = 76530000;
%% 1- Cross LPs
% Going through the empty slot at the FP, instead of the VVC, we'll cross
% LP1 and LP2 by *removing QWP2*, and doing a 2D search on rotations of QWP1 and LP2 

% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

tint_arr2 = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1.5,2,3,5];
numtint = numel(tint_arr2);

indtint = 1;

centrow = bench.andor.FocusRow;
centcol = bench.andor.FocusCol;
cropsize = 128;
hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);

dark0 = 0;

numRot = 10;
midLP = 100.7;%56.5;
midQWP = 56.6;%155.4;
delta_ang = 1;
rot_arrLP2 = linspace(midLP-delta_ang,midLP+delta_ang,numRot);
rot_arrQWP1 = linspace(midQWP-delta_ang,midQWP+delta_ang,numRot);
% rot_arrLP = linspace(0,339,numRot);
% rot_arrQWP = linspace(0,339,numRot);
peak_mat = zeros(numRot)*nan;
for II=1:numRot
    rotLP2 = rot_arrLP2(II);
    count = 1;
    while 1
        tint = tint_arr2(indtint);
        hcst_andor_setExposureTime(bench,tint);
        
        rotQWP1 = rot_arrQWP1(count);
        pos = hcst_LPQWP_move(bench,[nan,rotQWP1,rotLP2,nan]);
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
        imagesc(rot_arrQWP1,rot_arrLP2,peak_mat/ma_peak)
        axis image;
        xlabel('Rot QWP1 [deg]')
        ylabel('Rot LP2 [deg]')
        colorbar
        drawnow
        if count>numRot; break; end
    end
end
ma = max(peak_mat(:));
peak_norm_mat = peak_mat/ma_peak;
figure(333)
imagesc(rot_arrQWP1,rot_arrLP2,peak_norm_mat)
axis image;
xlabel('Rot QWP1 [deg]')
ylabel('Rot LP2 [deg]')
title('Extinction Ratio')
colorbar

%% See result. At this minimum, the LPs should be crossed at roughly 90deg and the QWP aligned to one of the LPs
[mi,ind_mi] = min(peak_mat(:)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
[ind_x,ind_y] = ind2sub(size(peak_mat),ind_mi);
disp(['LP2 rot: ', num2str(rot_arrLP2(ind_x)),' QWP1 rot: ', num2str(rot_arrQWP1(ind_y))])

%% Save result
% fitswrite(peak_mat,'test_peak_mat2.fits')
% save('2DSearch_QWP2Out_fineSearch_Nov01.mat','peak_mat','ma_peak','rot_arrQWP','rot_arrLP');
rotLP2_cross = rot_arrLP2(ind_x);
rotQWP1_cross = rot_arrQWP1(ind_y);
%% 2 - Cross polarization with both QWPs in
% Put QWP2 back in, rotate QWP1 45deg wrt to the min position found in the
% previous step, and do a 1D search with the rotation of QWP2

indtint = 1;
rotQWP1 = rotQWP1_cross + 45;

numRot = 100;
rot_arrQWP2 = linspace(0,340,numRot);
peak_arr = zeros(numRot,1)*nan;
count = 1;
while 1
    tint = tint_arr2(indtint);
    hcst_andor_setExposureTime(bench,tint);

    rotQWP2 = rot_arrQWP2(count);
    pos = hcst_LPQWP_move(bench,[nan,rotQWP1,rotLP2_cross,rotQWP2]);
    im0 = hcst_andor_getImage(bench) - dark0;

%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         im0 = im0 - median(im0(:));
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    peak = max(im0(:));

    figure(112);
    imagesc(log10_4plot(im0/2^16));
    axis image; 
    colorbar;%caxis([-4 0]);
    title([num2str(count)],'FontSize',32)
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
        peak_arr(count) = peak/tint;
        count = count+1;
    end
    figure(202)
    plot(rot_arrQWP2,peak_arr/ma_peak)
    xlabel('Rot QWP2 [deg]')
    ylabel('Extinction Ratio')
    drawnow
    if count>numRot; break; end
end

%% See result. 
[mi,ind_mi] = min(peak_arr(1:end)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
disp(['QWP2 rot: ', num2str(rot_arrQWP2(ind_mi))])
rotQWP1_45 = rotQWP1;
rotQWP2_45 = rot_arrQWP2(ind_mi);
pos = hcst_LPQWP_move(bench,[nan,rotQWP1_45,rotLP2_cross,rotQWP2_45]);

%% 3- Cross Fine tune the QWP to find the best crossing
% 2D search around the positions found, to search for the best crossing.
% The PSF should look cut in half

% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

indtint = 3;

numRot = 5;
delta_ang1 = 0.05;
delta_ang2 = 0.05;
rot_arrQWP1 = linspace(rotQWP1_45-delta_ang1,rotQWP1_45+delta_ang1,numRot);
rot_arrQWP2 = linspace(rotQWP2_45-delta_ang2,rotQWP2_45+delta_ang2,numRot);
% rot_arrLP = linspace(0,339,numRot);
% rot_arrQWP = linspace(0,339,numRot);
peak_mat = zeros(numRot)*nan;
for II=1:numRot
    rotQWP1 = rot_arrQWP1(II);
    count = 1;
    while 1
        tint = tint_arr2(indtint);
        hcst_andor_setExposureTime(bench,tint);
        
        rotQWP2 = rot_arrQWP2(count);
        pos = hcst_LPQWP_move(bench,[nan,rotQWP1,rotLP2_cross,rotQWP2]);
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
        figure(203)
        imagesc(rot_arrQWP2,rot_arrQWP1,peak_mat/ma_peak)
        axis image;
        xlabel('Rot QWP2 [deg]')
        ylabel('Rot QWP1 [deg]')
        colorbar
        drawnow
        if count>numRot; break; end
    end
end
ma = max(peak_mat(:));
peak_norm_mat = peak_mat/ma_peak;
figure(334)
imagesc(rot_arrQWP2,rot_arrQWP1,peak_norm_mat)
axis image;
xlabel('Rot QWP2 [deg]')
ylabel('Rot QWP1 [deg]')
title('Extinction Ratio')
colorbar

%% See result. At this minimum, the LPs should be crossed at roughly 90deg and the QWP aligned to one of the LPs
[mi,ind_mi] = min(peak_mat(:)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
[ind_x,ind_y] = ind2sub(size(peak_mat),ind_mi);
disp(['QWP1 rot: ', num2str(rot_arrQWP1(ind_x)),' QWP2 rot: ', num2str(rot_arrQWP2(ind_y))])

%% Accept result
rotQWP1_45 = rot_arrQWP1(ind_x);
rotQWP2_45 = rot_arrQWP2(ind_y);
% pos = hcst_LPQWP_move(bench,[nan,rotQWP1_45,rotLP2_cross,rotQWP2_45]);

%% Try with a 1D search on LP2
% Put QWP2 back in, rotate QWP1 45deg wrt to the min position found in the
% previous step, and do a 1D search with the rotation of QWP2

numRot = 25;
delta_ang = 5;
rot_arrLP2 = linspace(rotLP2_cross-delta_ang,rotLP2_cross+delta_ang,numRot);
peak_arr = zeros(numRot,1)*nan;
count = 1;
while 1
    tint = tint_arr2(indtint);
    hcst_andor_setExposureTime(bench,tint);

    rotLP2 = rot_arrLP2(count);
    pos = hcst_LPQWP_move(bench,[nan,rotQWP1_45,rotLP2,rotQWP2_45]);
    im0 = hcst_andor_getImage(bench) - dark0;

%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         im0 = im0 - median(im0(:));
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    peak = max(im0(:));

    figure(112);
    imagesc(log10_4plot(im0/2^16));
    axis image; 
    colorbar;%caxis([-4 0]);
    title([num2str(count)],'FontSize',32)
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
        peak_arr(count) = peak/tint;
        count = count+1;
    end
    figure(202)
    plot(rot_arrLP2,peak_arr/ma_peak)
    xlabel('Rot LP2 [deg]')
    ylabel('Extinction Ratio')
    drawnow
    if count>numRot; break; end
end

%% See result. 
[mi,ind_mi] = min(peak_arr(:)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
disp(['LP2 rot: ', num2str(rot_arrLP2(ind_mi))])

%% Accept result
rotLP2_cross = rot_arrLP2(ind_mi);
pos = hcst_LPQWP_move(bench,[nan,rotQWP1_45,rotLP2_cross,rotQWP2_45]);

im0 = hcst_andor_getImage(bench) - dark0;

peak = max(im0(:));

tint = 01;
hcst_andor_setExposureTime(bench,tint);
hcst_FPM_move(bench,[24.5 , 3, nan]);

figure(112);
imagesc(log10_4plot(im0/2^16));
axis image; 
colorbar;%caxis([-4 0]);
title([num2str(count)],'FontSize',32)
%     text(10,10,num2str(peak_rel),'Color','w','FontSize',32);
text(10,3,num2str(peak/ma_peak),'Color','w','FontSize',32);

%% Accept final result
bench.LPQWP.posLP1 = bench.LPQWP.axLP1.reqPosAct();
bench.LPQWP.posQWP1 = rotQWP1_45;
bench.LPQWP.posLP2 = rotLP2_cross;
bench.LPQWP.posQWP2 = rotQWP2_45;
disp(['Min extinction ratio: ', num2str(peak/ma_peak)])
disp(['LP1 rot: ', num2str(bench.LPQWP.axLP1.reqPosAct())])
disp(['QWP1 rot: ', num2str(rotQWP1_45)])
disp(['LP2 rot: ', num2str(rotLP2_cross)])
disp(['QWP2 rot: ', num2str(rotQWP2_45)])

%% Check polarization contrast, i.e. the ratio between going thru the empty slot and going thru the VVC

% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

tint = 0.1;
hcst_andor_setExposureTime(bench,tint);
im0 = hcst_andor_getImage(bench) - dark0;
peak_crossed = max(im0(:))/tint;

disp(['Max counts at peak: ',num2str(max(im0(:)))])
% Move to VVC mask
hcst_FPM_move(bench,[1 ,1, bench.FPM.VORTEX_F0]);

hcst_FW_setPos(bench,2);% Focus viewing mode
nd_fact = 100;

indtint = 2;
while 1
    tint = tint_arr2(indtint);
    hcst_andor_setExposureTime(bench,tint);

    im0 = hcst_andor_getImage(bench) - dark0;

    peak = max(im0(:));

    figure(112);
    imagesc(log10_4plot(im0/2^16));
    axis image; 
    colorbar;%caxis([-4 0]);
%     title([num2str(count)],'FontSize',32)
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
        peak_vvc = peak/tint*nd_fact;
        break
    end
end

polContrast = peak_crossed/peak_vvc;

disp(['Polarization contrast: ',num2str(polContrast)])
%%
hcst_disconnectDevices(bench, false, false)
% return

%% 2D search with QWPs
rotLP1_45 = bench.LPQWP.posLP1;
rotQWP1_45 = bench.LPQWP.posQWP1;
rotLP2_45 = bench.LPQWP.posLP2;
rotQWP2_45 = bench.LPQWP.posQWP2;
% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

tint_arr2 = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1.5,2,3,5];
numtint = numel(tint_arr2);

dark0 = 1;
indtint = 5;
ma_peak = 76530000;

numRot = 5;
delta_ang = 0.1;
rot_arrQWP1 = linspace(rotQWP1_45-delta_ang,rotQWP1_45+delta_ang,numRot);
rot_arrQWP2 = linspace(rotQWP2_45-delta_ang,rotQWP2_45+delta_ang,numRot);
% rot_arrLP = linspace(0,339,numRot);
% rot_arrQWP = linspace(0,339,numRot);
peak_mat = zeros(numRot)*nan;
for II=1:numRot
    rotQWP1 = rot_arrQWP1(II);
    count = 1;
    while 1
        tint = tint_arr2(indtint);
        hcst_andor_setExposureTime(bench,tint);
        
        rotQWP2 = rot_arrQWP2(count);
        pos = hcst_LPQWP_move(bench,[rotLP1_45,rotQWP1,rotLP2_45,rotQWP2]);
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
        figure(203)
        imagesc(rot_arrQWP2,rot_arrQWP1,peak_mat/ma_peak)
        axis image;
        xlabel('Rot QWP2 [deg]')
        ylabel('Rot QWP1 [deg]')
        colorbar
        drawnow
        if count>numRot; break; end
    end
end
ma = max(peak_mat(:));
peak_norm_mat = peak_mat/ma_peak;
[mi,ind_mi] = min(peak_mat(:)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
[ind_x,ind_y] = ind2sub(size(peak_mat),ind_mi);
disp(['QWP1 rot: ', num2str(rot_arrQWP1(ind_x)),' QWP2 rot: ', num2str(rot_arrQWP2(ind_y))])
colorbar

%% Accept result
bench.LPQWP.posQWP1 = rot_arrQWP1(ind_x);
bench.LPQWP.posQWP2 = rot_arrQWP2(ind_y);
hcst_LPQWP_move(bench,[nan,bench.LPQWP.posQWP1,nan,bench.LPQWP.posQWP2]);
im0 = hcst_andor_getImage(bench) - dark0;
figure(112);
imagesc(log10_4plot(im0/2^16));
axis image; 

%%
hcst_LPQWP_move(bench,[bench.LPQWP.posLP1,bench.LPQWP.posQWP1,bench.LPQWP.posLP2,bench.LPQWP.posQWP2]);
