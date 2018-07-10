function hcst_andor_setSensorCooling(B,cooleron,wait4stability)
%hcst_andor_setSensorCooling(B,cooleron,wait4stability)
%Turns on/off the cooling of the Andor Neo camera. 
%
%   - Updates the 'B.bench' struct 
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%       'cooleron' - logical - true = on, false = off
%       'wait4stability' - logical - Wait for the temp to stabilize


    andor_handle = B.bench.andor.andor_handle;

    if(cooleron)
        disp('Turning on sensor cooling...');
        B.bench.andor.sensorCooling = true;
    else
        disp('Turning off sensor cooling...');
        B.bench.andor.sensorCooling = false;
    end

    
    % Turn on/off cooling 
    featurePtr = libpointer('voidPtr',[int32('SensorCooling'),0]);
    err = calllib('lib', 'AT_SetBool', andor_handle, featurePtr, int32(cooleron));
    if(err~=0)
        disp('Failed to set sensorCooling.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetBool']);
    end

    disp(['     Current sensor temp:',num2str(hcst_andor_getSensorTemp(B))]);


    % Get temperature control count (number of options)
    featurePtr = libpointer('voidPtr',[int32('TemperatureControl'),0]);
    queryPtr = libpointer('int32Ptr',int32(0));
    err = calllib('lib', 'AT_GetEnumCount', andor_handle, featurePtr, queryPtr);
    if(err~=0)
        disp('Failed to set sensorCooling.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetEnumCount']);
    end
    tmp = get(queryPtr);
    count = tmp.Value;

    if(cooleron)
        goalTempIndex = count - 1;
%         goalTempIndex = 1;
    else
        goalTempIndex = 0;
    end
    
    % Set the temperature to the lowest possible value
    err = calllib('lib', 'AT_SetEnumIndex', andor_handle, featurePtr, int32(goalTempIndex));
    if(err~=0)
        disp('Failed to set sensorCooling.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetEnumIndex']);
    end

    % Get the temperature control index string
    queryPtr = libpointer('voidPtr',int32(zeros(1,256)));
    err = calllib('lib', 'AT_GetEnumStringByIndex', andor_handle, featurePtr, ...
                int32(goalTempIndex),queryPtr,int32(256));
    if(err~=0)
        disp('Failed to set sensorCooling.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetEnumStringByIndex']);
    end
    tmp = get(queryPtr);
    temperatureControl = tmp.Value;
    disp(['     Temperature set to ',char(temperatureControl),'deg']);

    % Get the temperature status index
    featurePtr = libpointer('voidPtr',[int32('TemperatureStatus'),0]);
    queryPtr = libpointer('int32Ptr',int32(0));
    err = calllib('lib', 'AT_GetEnumIndex', andor_handle, featurePtr, queryPtr);
    if(err~=0)
        disp('Failed to set sensorCooling.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetEnumIndex']);
    end
    tmp = get(queryPtr);
    statusIndex = tmp.Value;


    % Get the temperature status index string
    queryPtr = libpointer('voidPtr',int32(zeros(1,256)));
    err = calllib('lib', 'AT_GetEnumStringByIndex', andor_handle, featurePtr, ...
                int32(statusIndex),queryPtr,int32(256));
    if(err~=0)
        disp('Failed to set sensorCooling.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetEnumStringByIndex']);
    end
    tmp = get(queryPtr);
    status = tmp.Value;
    disp(['     ',char(status)]);

	if(wait4stability && cooleron)
        disp('     Waiting for temp to stabilize...');
        while(~strcmp(deblank(char(status)),'Stabilised'))

            % Get the temperature status index
            featurePtr = libpointer('voidPtr',[int32('TemperatureStatus'),0]);
            queryPtr = libpointer('int32Ptr',int32(0));
            err = calllib('lib', 'AT_GetEnumIndex', andor_handle, featurePtr, queryPtr);
            if(err~=0)
                disp('Failed to set sensorCooling.');
                error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetEnumIndex']);
            end
            tmp = get(queryPtr);
            statusIndex = tmp.Value;


            % Get the temperature status index string
            queryPtr = libpointer('voidPtr',int32(zeros(1,256)));
            err = calllib('lib', 'AT_GetEnumStringByIndex', andor_handle, featurePtr, ...
                        int32(statusIndex),queryPtr,int32(256));
            if(err~=0)
                disp('Failed to set sensorCooling.');
                error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetEnumStringByIndex']);
            end
            tmp = get(queryPtr);
            status = tmp.Value;
            status = char(status);
            % disp(['     ',status(1:10),'... temp=',num2str(hcst_andor_getSensorTemp(B))]);

        end
       disp('     Stabilized.');
    else
        disp('     Not waiting to stabilize.');
    end
    

end

