% ArdTimeConversion
%
% a series of code used to determine how much faster the arduino runs than
% real time
% 
% written by Grady Morrissey July 2019





numint = 100;
arrtimetest  ard = cell(numint,3);

for II = 1:numint
    time = hcst_getArduinoTime()
    timeprev = hcst_getArduinoTime()
    tic
    while timeprev == time
        time = hcst_getArduinoTime()
    end
    elap = toc
    acttime = clock;
    arrtimetestard{II,1} = time;
    arrtimetestard{II,2} = acttime;
    arrtimetestard{II,3} = elap;
end

% dat = arrtimetestard;
% dat = dat(:,3);
% tot = 0;
% hm = size(dat);
% for II = 1:hm(1)
%     tot = tot + dat{II,1};
% end
% av = tot/hm(1)

% dat = arrtimetestard;
% sz = size(dat);
% newcell = cell(
% lasttime = dat{sz(1),2};
% newtime = dat{sz(1)-JJ,2};
% dif = lasttime - newtime
% timedifsec = dif(4) * 60*60 + dif(5)*60 + dif(6)


