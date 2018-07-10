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
bench = hcst_config();
% bench = hcst_setUpBench(bench);
fprintf("___'bench' struct created successfully\n\n")

bench = hcst_setUpAndor(bench);

%% Call Andor test function

tint = 0.0001;
bench.andor.numCoadds = 1;
bench = hcst_andor_setExposureTime(bench,tint);

tic;
im = hcst_andor_getImage(bench);
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

bench = hcst_cleanUpAndor(bench);

