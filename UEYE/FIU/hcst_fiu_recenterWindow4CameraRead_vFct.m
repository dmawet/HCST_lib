% hcst_fiu_recenterWindow4CameraRead_vFct.m
%
% Find center of camera read SMF. This function is intended for using
% everytime the FEUzaber has moved since the fiber may be too tense to
% avoid it touching the focusing lens
%
% Jorge Llop - Oct 24, 2020


function [ bench ] = hcst_fiu_recenterWindow4CameraRead_vFct(bench,im0)

sz = size(im0);
[~,ind_ma] = max(im0(:));
[ind_x,ind_y] = ind2sub(sz,ind_ma);

dx = sz(1)/2 - ind_x-1;
dy = sz(2)/2 - ind_y-1;

hcst_andor_setSubwindow(bench,bench.andor.FEURow-dx,...
    bench.andor.FEUCol-dy,128);

%% Accept result
bench.andor.FEURow=bench.andor.FEURow-dx;
bench.andor.FEUCol=bench.andor.FEUCol-dy;
X= ['recenterWindow4Camera Done with dx=', num2str(dx), '; dy=', num2str(dy)];
disp(X);
end