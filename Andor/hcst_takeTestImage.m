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

hcst_setUpAndor(bench, false);

%% Call Andor test function

% Set the exposure time
tint = 0.0001;
hcst_andor_setExposureTime(bench,tint);

tic;
im = hcst_andor_getImage(bench);
toc;


%%

figure;
imagesc(double(im)/2^16);
axis image; 
colorbar;

%%

hcst_cleanUpAndor(bench);

