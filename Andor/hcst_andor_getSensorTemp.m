function temp = hcst_andor_getSensorTemp(bench)
%hcst_andor_getSensorTemp Queries the temperature of the Andor Neo camera sensor
%
%   - Returns the current sensor temp
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%   Outputs
%       'temp' - The temperature in degrees Celsius

    andor_handle = bench.andor.andor_handle;


    featurePtr = libpointer('voidPtr',[int32('SensorTemperature'),0]);
    queryPtr = libpointer('doublePtr',0);
    err = calllib('lib', 'AT_GetFloat', andor_handle, featurePtr, queryPtr);
    if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetFloat']);
    end
    Query = get(queryPtr);
    temp = Query.Value;
    
    
end

