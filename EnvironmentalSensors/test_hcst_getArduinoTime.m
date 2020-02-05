% test_hcst_getArduinoTime.m
%
% Runs hcst_getArduinoTime repeatedly
% outputs the current time on the Arduino
% 
% written by Grady Morrissey July 2019

numtry = 20;
for a=1:numtry
    ArduinoTime = hcst_getArduinoTime()
end
