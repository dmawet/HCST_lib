% hcst_fiu_aperturePhotometryOnAndor.m
%
% Perform aperture photmetry with the andor neo camera and return
% integrated counts
% Aug11, 2021: added a Gaussian filter to find better the center for low
% flux
% Jorge Llop - Aug 17, 2020

function [ int ] = hcst_fiu_aperturePhotometryOnAndor(bench,im,flagCenterMask,varargin)

if(nargin>3)
    fwhm = varargin{1};
    factorAperture = 1;
else
    factorAperture = 1.645;
    fwhm = bench.FIUstages.gaussianFWHM*bench.NKT.lambda/775;
end
sz = size(im);
cropsize = sz(1);

if flagCenterMask
    im_filt = imgaussfilt(im,fwhm);
    [~,ind_ma] = max(im_filt(:));
    [ind_x,ind_y] = ind2sub(sz,ind_ma);
    dx = sz(1)/2 - ind_x;
    dy = sz(2)/2 - ind_y;
else
    dx = 0;
    dy = 0;
end
[X,Y] = meshgrid(-cropsize/2+1:cropsize/2,-cropsize/2+1:cropsize/2);
[~,RHO] = cart2pol(X+dy+1,Y+dx+1);
maskcenter = zeros(cropsize);
maskcenter(RHO<(fwhm*factorAperture/2)) = 1;

int = sum(sum(im.*maskcenter));
% figure;imagesc(maskcenter);axis image
end

