% hcst_getCSVname.m
%
%gives previous envi sensing filename (string) for hcst.getHistData() given current
%filename
% 
%example prevname and output is '20190731.csv'
% 
% written by Grady Morrissey July 2019

%gives previous envi sensing filename (string) for hcst.getHistData() given current
%filename

%example prevname and output is '20190731.csv'


function prevname = hcst_getCSVname(currname)
currnum = char(currname);
curyear = currnum(1:4);
curyear = str2num(curyear);
curmon = currnum(5:6);
curmon = str2num(curmon);
curday = currnum(7:8);
curday = str2num(curday);

montharr = [31,28,31,30,31,30,31,31,30,31,30,31];

prevday = curday - 1;
prevmon = curmon;
prevyear = curyear;
if prevday == 0
    prevmon = curmon - 1;
    if prevmon == 0
        prevmon = 12;
        prevyear = curyear - 1;
    end
    prevday = montharr(prevmon);
end

yrstr = string(num2str(prevyear));
monstr = string(num2str(prevmon));
daystr = string(num2str(prevday));

while strlength(yrstr) < 4
    yrstr = "0" + yrstr;
end
while strlength(monstr) < 2
    monstr = "0" + monstr;
end
while strlength(daystr) < 2
    daystr = "0" + daystr;
end
prevname = yrstr + monstr + daystr + ".csv";



end
    
    