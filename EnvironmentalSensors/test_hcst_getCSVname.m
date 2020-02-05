% test_hcst_getCSVname.m
%
% tests hcst_getCSVname for input file name
% Given filename, it calculates the previous filename
%Used in hcst_getHistData
%
% 
% written by Grady Morrissey July 2019


% now = webread("http://192.168.1.3/now");
% filename = now{1,1};
% filename = char(filename)



filenum = 19981001
filename = num2str(filenum) + ".csv"

hcst_getCSVname(filename)