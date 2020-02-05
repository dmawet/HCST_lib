% hcst_getHistData
%
% reads data file from arduino and saves it
% input history duration (time) in seconds
% 
% 
% NOTE -- There are problems with this code
% Arduino time runs faster than actual time
% If the Arduino loses power, the date/file resets to July 31, 2019
%This means new data is appended on top of old data
%The code would optimally have some sort of safeguard to check if the
%Arduino was reset and deal with the old data
% 
% 
% 
% 
% written by Grady Morrissey July 2019
% v2: trying to plot Variables vs Time


function hcst_getHistDatav2(histtime,pathout)


%current time for plotting
currtime = clock; 
starttime = TimeDisplay();

%Arduino time runs faster than actual clock
%120 seconds real time approx equals x seconds Arduino time

%conversion = 120^2/128.9947;
% conversion = 102.5732;
%conversion = 87.18;
conversion = 90;

%get current file name
now = webread("http://192.168.1.3/now");
filename = now{1,1};
csvname = char(filename);

%how much data has been read (in time)
readtime = 0;

%create cell array for adding data
filecell = {};
totcell = {};


%while less data than requested has been read (in seconds)
while readtime <= histtime
    try
        %read current file
        url = "http://192.168.1.3/" + string(csvname);
        data = (webread(url));
        data = table2cell(data);
    catch
        warning('More data requested than exists')
        break
    end
    
    %find size of current data file and convert to seconds
    sz = size(data);
    
    %Protect against multiple days of data in one file (from Arduino power
    %reset)
    %each file should cap at 720 rows of data
    %INCOMPLETE
    if sz(1) > 720
        numresets = fix(sz(1)/720);
        rc = 720 * numresets;
        data = data(rc+1:sz(1),:);
    end
    
    %reset data size
    sz = size(data);
    datalen = sz(1) * conversion;

    %if only one line of data requested
    
    
    
    %check if histtime  = 100000
    
    if histtime <= conversion
        filecell = data(1,:);
    else
        %if the file has all the data
        if datalen > histtime
            rows = ceil(histtime/conversion);
            filecell = data(sz(1)-rows+1:sz(1),:);
        elseif datalen == histtime
            filecell = data;
        %if the file doesnt have enough data
        elseif datalen < histtime
            filecell = data;
            csvname = hcst_getCSVname(csvname);
        end
    end
    
    totcell = vertcat(filecell,totcell);
    readtime = readtime + datalen;
    
end

%Convert Arduino time to actual time
totsize = size(totcell);
timecell = cell(totsize(1),1);

for LL = 1:totsize(1)
    hr = currtime(4);
    mn = currtime(5);
    sc = currtime(6);
    
    timesec = hr*60*60+mn*60+sc;
    timesec = timesec - conversion*(LL-1);
    
    hr = string(num2str(fix(timesec/60/60)));
    r = mod(timesec,60*60);
    mn = string(num2str(fix(r/60)));
    sc = string(num2str((mod(r,60))));
    
    if strlength(hr) < 2
        hr = "0" + hr;
    end
    if strlength(mn) < 2
        mn = "0" + mn;
    end
    if strlength(sc) < 2
        sc = "0" + sc;
    end
    
    timestr = char(hr + ":" + mn + ":" + sc);
    
    timecell{totsize(1)-LL+1,1} = timestr;
end

totcell = totcell(:,2:totsize(2));
totcell = horzcat(timecell,totcell);


%set up and save table
histtable = cell2table(totcell);
%made with stringbuilder.py
keysstr = "Time,Temp_S1,Humidity_S1,Pressure_S1,XAccel_S1,YAccel_S1,ZAccel_S1,XGyro_S1,YGyro_S1,ZGyro_S1,XMag_S1,YMag_S1,ZMag_S1,Temp_S2,Humidity_S2,Pressure_S2,XAccel_S2,YAccel_S2,ZAccel_S2,XGyro_S2,YGyro_S2,ZGyro_S2,XMag_S2,YMag_S2,ZMag_S2,Temp_S3,Humidity_S3,Pressure_S3,XAccel_S3,YAccel_S3,ZAccel_S3,XGyro_S3,YGyro_S3,ZGyro_S3,XMag_S3,YMag_S3,ZMag_S3,Temp_S4,Humidity_S4,Pressure_S4,XAccel_S4,YAccel_S4,ZAccel_S4,XGyro_S4,YGyro_S4,ZGyro_S4,XMag_S4,YMag_S4,ZMag_S4,Temp_S5,Humidity_S5,Pressure_S5,XAccel_S5,YAccel_S5,ZAccel_S5,XGyro_S5,YGyro_S5,ZGyro_S5,XMag_S5,YMag_S5,ZMag_S5,Temp_S6,Humidity_S6,Pressure_S6,XAccel_S6,YAccel_S6,ZAccel_S6,XGyro_S6,YGyro_S6,ZGyro_S6,XMag_S6,YMag_S6,ZMag_S6,Temp_S7,Humidity_S7,Pressure_S7,XAccel_S7,YAccel_S7,ZAccel_S7,XGyro_S7,YGyro_S7,ZGyro_S7,XMag_S7,YMag_S7,ZMag_S7,Temp_S8,Humidity_S8,Pressure_S8,XAccel_S8,YAccel_S8,ZAccel_S8,XGyro_S8,YGyro_S8,ZGyro_S8,XMag_S8,YMag_S8,ZMag_S8";
keys = strsplit(keysstr,',');
headers = cell(1,length(keys));
for FF = 1:length(keys)
    headers{FF} = char(keys{FF});
end

histtable.Properties.VariableNames = {headers{:,:}};

%prepare to save file
hr = string(num2str(fix(histtime/60/60)));
r = mod(histtime,60*60);
minu = string(num2str(fix(r/60)));
sec = string(num2str((mod(r,60))));

histdur = hr +"hr"+minu+"m"+sec+"s";
matfilename = starttime + "_HistData_" + histdur + ".xlsm";
matfilepath = pathout + matfilename;

%save file
% writetable(histtable, matfilepath);


%% Trying to plot - Need debugging
% %Plot
% %NEED TO CONVERT TIME TO A PLOTABLE FORMAT
% %
% 
% categories = ["Temperature [C]" "Humidity" "Pressure" "Accel Y"];
% catindex = [1,2,3,5];
% 
% %for each category
% for CC = 1:size(catindex)
%     figure('color','w')
%     title(categories(CC))
%     xlabel('Time')
%     ylabel(categories(CC))
%     %for each sensor
%     for SS = 1:8
%         %for each time
%         val_arr = [];
% %         time_arr = [];
%         for TT = 1:totsize(1)
%             plottime = char(totcell{TT,1});
%             %maybe use datenum
% %             plot(plottime,totcell{TT,1+catindex(CC)+12*(TT-1)})
%             val_arr = [val_arr,totcell{TT,1+catindex(CC)+12*(TT-1)}];
% %             time_arr = [time_arr,str2num(plottime)];
%             hold on
%         end
%         plot(val_arr)
%     end
%     hold off
%     legend('Sensor 1', 'Sensor 2','Sensor 3', 'Sensor 4','Sensor 5', 'Sensor 6','Sensor 7', 'Sensor 8')
% 
% 
% 
% % USE TOTCELL FOR PLOTTING
% % % Plot Temperture
% % figure('color','w')
% % for II=1:8
% %     plot(time_arr,temp_arr)
% %     hold on
% % end
% % hold off
% % xlabel('Time')
% % ylabel('Temp [C]')
% % legend('Sensor 1', 'Sensor 2','Sensor 3', 'Sensor 4','Sensor 5', 'Sensor 6','Sensor 7', 'Sensor 8')
% % 
% % % Plot Humidity
% % figure('color','w')
% % for II=1:8
% %     plot(time_arr,temp_arr)
% %     hold on
% % end
% % hold off
% % xlabel('Time')
% % ylabel('Humidity [%]')
% % legend('Sensor 1', 'Sensor 2','Sensor 3', 'Sensor 4','Sensor 5', 'Sensor 6','Sensor 7', 'Sensor 8')
% end


end
