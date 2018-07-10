function tint = hcst_andor_getExposureTime(B)
%tint = hcst_andor_getExposureTime(B)
%Queries the exposure time setting of the Andor Neo camera
%
%   - Returns the current exposure time
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%   Outputs
%       'tint' - The exposure time in seconds 

    andor_handle = B.bench.andor.andor_handle;

    % Equivalent to AT_SetFloat(Handle, L”ExposureTime”, 0.01);
    expTimeFeaturePtr = libpointer('voidPtr',[int32('ExposureTime'),0]);
    tintQueryPtr = libpointer('doublePtr',0);
    err = calllib('lib', 'AT_GetFloat', andor_handle, expTimeFeaturePtr, tintQueryPtr);
    if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetFloat']);
    end
    tintQuery = get(tintQueryPtr);
    tint = tintQuery.Value;
    
    
end

