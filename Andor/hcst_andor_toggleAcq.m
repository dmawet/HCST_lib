function hcst_andor_toggleAcq(bench,onoff)
%hcst_andor_toggleAcq Starts or stops acquisition 
%
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'onoff' - True for start acquisition, False to stop acquisition 

andor_handle = bench.andor.andor_handle;

if(and(bench.andor.acquiring, onoff))
    disp('Acquisition was already on.');
elseif(and(~bench.andor.acquiring, ~onoff))
    disp('Acquisition was already off.');
else
    
   
    % Equivalent to AT_Command(Handle, L"AcquisitionStart");
    % or AT_Command(Handle, L"AcquisitionStop");
    if(onoff)
        acqStrPtr = libpointer('voidPtr',int32(['AcquisitionStart',0]));
    else
        acqStrPtr = libpointer('voidPtr',int32(['AcquisitionStop',0]));
    end

    err = calllib('lib', 'AT_Command', andor_handle, acqStrPtr);
    if(err~=0)
        if(onoff)
            disp('Failed to start acquisition!');
        else
            disp('Failed to stop acquisition!');
        end
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Command']);
    end

    
    % Update the 'bench' struct to contain actual exposure time
    bench.andor.acquiring = onoff;
end
    
end

