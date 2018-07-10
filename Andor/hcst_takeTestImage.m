%{
Script to test the hcst_[...] functions
******************************************************
This script runs through the hcst_[...] functions to check that they are
working correctly. It basically calls the individual test functions
associated with each device.
******************************************************
%}

clear; close all;
addpath(genpath('/home/hcst/HCST_lib/'));

%% Create and populate bench struct
fprintf("\n___Creating 'bench' struct\n")
B = hcst_config();
% bench = hcst_setUpBench(bench);
fprintf("___'bench' struct created successfully\n\n")

hcst_setUpAndor(B);

%% Call Andor test function

tint = 0.0001;
B.bench.andor.numCoadds = 1;
hcst_andor_setExposureTime(B,tint);

tic;
im = hcst_andor_getImage(B);
toc;


%%
[rows,cols] = size(im);
centx = 1294;
centy = 1559; 
cropsize = 512;

croprows = centy-cropsize/2+1:centy+cropsize/2;
cropcols = centx-cropsize/2+1:centx+cropsize/2;

figure;
imagesc(double(im(croprows,cropcols))/2^16);
axis image; 
colorbar;

%%

hcst_cleanUpAndor(B);

