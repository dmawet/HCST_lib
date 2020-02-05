% hcst_getEnviData
%
% Returns a 2d array of value = {sensor #, category} for current time
% Runs using 192.168.1.3/now
% 
% 
% written by Grady Morrissey July 2019

%UNITS
% Time is UTC
% Humidity is %
% Pressure is hPa or millibar
% Accel is m/s^2
% Gyro is degrees/s
% Mag is gauss
hcst_getHistData
function tbl = hcst_getEnviData()
    %
    %call it like : hcst_getEnviData()
    %
    %Empty ports generate "NaN" values
    %
    %
    data = (webread('http://192.168.1.3/now'));
    data = data{3,:};
    
    %TOSS THE TIME VALUE -- CAN COME BACK TO THIS IF NEEDED
    data = data(2:length(data));

    %THIS CUTS THE EMPTY SENSOR PORTS OFF
    numsensors = 8;
    data = data(1:numsensors*12);
    
    %TIME IS REMOVED FROM KEYS UNTIL NEEDED
    catstr = "temp,humidity,pressure,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magX,magY,magZ";

    keys = strsplit(catstr,',');
    
    %empty cell array for data (sensors v. categories)
    cll = cell(numsensors,length(keys));
    
    %add data
    [ycell,xcell] = size(cll);
    for BB = 1:ycell
        for VV = 1:xcell
            cll{BB,VV} = str2double(data{VV+xcell*(BB-1)});
        end
    end
    
    %CONVERT TO TABLE SO THERE'S HEADERS
    tbl = cell2table(cll);
    headers = cell(1,length(keys));
    for FF = 1:length(keys)
        headers{FF} = char(keys{FF});
    end
    sensnums = cell(1,numsensors);
    for FF = 1:numsensors
        sensnums{FF} = char(num2str(FF));
    end
    sensnums;
    tbl.Properties.VariableNames = {headers{:,:}};
    tbl.Properties.RowNames = {sensnums{:,:}};
end
   