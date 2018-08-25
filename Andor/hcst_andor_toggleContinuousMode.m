function hcst_andor_toggleContinuousMode(bench,onoff)
%hcst_andor_toggleContinuousMode(bench,onoff) Starts or stops continuous mode 
%
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'onoff' - True for 'continuous' mode , False for 'fixed' mode 

andor_handle = bench.andor.andor_handle;

if(and(bench.andor.continuous, onoff))
    disp('Andor Neo was already in continuous mode.');
elseif(and(~bench.andor.continuous, ~onoff))
    disp('Andor Neo was already in fixed mode.');
else
    
    % Set the camera to continuously acquires frames
    % AT_SetEnumString(Handle, L"CycleMode", L"Continuous");
    cyclemode = onoff; %Index for cyclemodes 
    featurePtr = libpointer('voidPtr',[int32('CycleMode'),0]);
    err = calllib('lib', 'AT_SetEnumIndex', andor_handle, featurePtr, int32(cyclemode));
    if(err~=0)
        disp('Failed to set cycle mode.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetEnumIndex']);
    end
    

    % Update the 'bench' struct
    bench.andor.continuous = onoff;
    
    if(bench.andor.continuous)
        disp('Andor Neo set to continuous mode.');
    else
        disp('Andor Neo set to fixed mode.');
    end
end
    
end

