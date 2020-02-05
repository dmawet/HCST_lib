% hcst_getHistData
%
%reads time from Arduino /now
%Arduino time is different from actual current time
% 
% written by Grady Morrissey July 2019

function ArdTime = hcst_getArduinoTime()
    %
    %
    %
    webdata = (webread('http://192.168.1.3/now'));
    ArdTime = webdata{3,1};
    ArdTime = ArdTime{1,1};
end
   