function hcst_andor_setFrameRate(bench,rate)
%hcst_andor_setFrameRate Changes the frame rate of the Andor Neo camera
%
%   - Sets the exposure time to tint
%   - Updates the 'bench' struct using
%       the hcst_andor_getExposureTime function.
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'rate' - Frame rate in Hz

    andor_handle = bench.andor.andor_handle;
    
    % Equivalent to AT_SetFloat(Handle, L”FrameRate”, 100);
    featurePtr = libpointer('voidPtr',[int32('FrameRate'),0]);
	queryPtr = libpointer('doublePtr',0);
    err = calllib('lib', 'AT_GetFloatMax', andor_handle, featurePtr, queryPtr);
    if(err~=0)
        disp('Failed to get the max frame rate.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetFloatMax']);
    end
    query = get(queryPtr);
    maxrate = query.Value;
    
    if(rate>maxrate)
        rate = maxrate;
    end
    
    % Equivalent to AT_SetFloat(Handle, L”FrameRate”, 100);
    err = calllib('lib', 'AT_SetFloat', andor_handle, featurePtr, rate);
    if(err~=0)
        disp('Failed to change the frame rate.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetFloat']);
    end
    
    % Update the 'bench' struct to contain actual exposure time
    new_rate = hcst_andor_getFrameRate(bench);
    bench.andor.frameRate = new_rate;
    
    disp(['Andor Neo frame rate set to ',num2str(new_rate),'Hz (max is ',num2str(maxrate),'Hz)']);
    
end

