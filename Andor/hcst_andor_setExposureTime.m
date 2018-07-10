function hcst_andor_setExposureTime(B,tint)
%bench = hcst_andor_setExposureTime(B,tint)
%Changes the exposure time of the Andor Neo camera
%
%   - Sets the exposure time to tint
%   - Updates the 'B.bench' struct using using
%       the hcst_andor_getExposureTime function.
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%       'tint' - The exposure time in seconds

    andor_handle = B.bench.andor.andor_handle;

    % Equivalent to AT_SetFloat(Handle, L”ExposureTime”, 0.01);
    expTimeFeaturePtr = libpointer('voidPtr',[int32('ExposureTime'),0]);
    err = calllib('lib', 'AT_SetFloat', andor_handle, expTimeFeaturePtr, tint);
    if(err~=0)
        disp('Failed to change the exposure time.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetFloat']);
    end
    
    % Update the 'bench' struct to contain actual exposure time
    new_tint = hcst_andor_getExposureTime(B);
    B.bench.andor.tint = new_tint;
    
    
end

