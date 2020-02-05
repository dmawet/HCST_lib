% test_hcst_SensorMapTimed
%
%saves a GIF and an Excel file
%#s below in seconds
% 
% written by Grady Morrissey July 2019

addpath('utils')

interval = 1; % seconds
duration = 10*60; % total secons
hcst_SensorMapTimed(interval,duration)