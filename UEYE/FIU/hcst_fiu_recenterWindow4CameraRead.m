% hcst_fiu_recenterWindow4CameraRead.m
%
% Find center of camera read SMF 
%
% Jorge Llop - Oct 16, 2020

FSpos = [bench.FS.V0, bench.FS.H0, bench.FS.F0];
resPos = hcst_FS_move(bench,FSpos);

tint =1e-2;
hcst_andor_setExposureTime(bench,tint);


hcst_andor_setSubwindow(bench,bench.andor.FEURow,...
    bench.andor.FEUCol,128);
im0 = hcst_andor_getImage(bench);

sz = size(im0);

figure(223)
imagesc(im0)
axis image
colorbar
title('Check if it Saturates!')

[ma,ind_ma] = max(im0(:));
[ind_x,ind_y] = ind2sub(sz,ind_ma);

dx = sz(1)/2 - ind_x-1;
dy = sz(2)/2 - ind_y-1;

hcst_andor_setSubwindow(bench,bench.andor.FEURow-dx,...
    bench.andor.FEUCol-dy,128);
im0 = hcst_andor_getImage(bench);

figure(224)
imagesc(im0)
axis image
colorbar
title('Check if it Saturates!')

%% Accept result
bench.andor.FEURow=bench.andor.FEURow-dx;
bench.andor.FEUCol=bench.andor.FEUCol-dy;