% TimeDisplay
%
% %makes a string of the current time for displaying
% output is of the form - "Jul31-2019_12-23-57"
% 
% written by Grady Morrissey July 2019

function timestr = TimeDisplay()
    %get current time
    a = clock;
    yr = num2str(a(1));
    %round sec to int
    sec = num2str(round(a(6)));
    minute = num2str(a(5));
    hour = num2str(a(4));
    day = num2str(a(3));
    montharray = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    month = montharray(a(2));
    if strlength(sec) < 2
            sec = "0" + sec;
    elseif strlength(minute) < 2
            minute = "0" + minute;
    elseif strlength(hour) < 2
            hour = "0" + hour;
    end
    
    %cant use ":" as it causes error in file save
    timestr = month+day+"-"+yr+"_"+hour+"-"+minute+"-"+sec;
    
end