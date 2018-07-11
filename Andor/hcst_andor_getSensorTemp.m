function temp = hcst_andor_getSensorTemp(B)
%hcst_andor_getSensorTemp Queries the temperature of the Andor Neo camera sensor
%
%   - Returns the current sensor temp
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%   Outputs
%       'temp' - The temperature in degrees Celsius

    andor_handle = B.bench.andor.andor_handle;

    % Equivalent to AT_SetFloat(Handle, L”ExposureTime”, 0.01);
    FeaturePtr = libpointer('voidPtr',[int32('SensorTemperature'),0]);
    QueryPtr = libpointer('doublePtr',0);
    err = calllib('lib', 'AT_GetFloat', andor_handle, FeaturePtr, QueryPtr);
    if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetFloat']);
    end
    Query = get(QueryPtr);
    temp = Query.Value;
    
    
end

