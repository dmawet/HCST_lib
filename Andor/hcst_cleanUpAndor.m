function hcst_cleanUpAndor(bench)
%hcst_cleanUpAndor Closes connection with the Andor Neo and cleans up
%   - This function should be called when finished funning the Andor Neo
%      functions
%   - It uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:
%   hcst_cleanUpAndor(bench) 
%       Closes the Andor Neo libraries
%       Cleans the andor sub-struct from bench
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpAndor(bench)
%           Updates 'bench', disconnects the andor


% -------------------------------------------------------------------%

if(isfield(bench.andor,'acquiring'))
    if(bench.andor.acquiring)
        % Equivalent to AT_Command(Handle, L"AcquisitionStop");
        acqStopStrPtr = libpointer('voidPtr',int32(['AcquisitionStop',0]));

        err = calllib('lib', 'AT_Command', bench.andor.andor_handle, acqStopStrPtr);
        if(err~=0)
            disp('Failed to stop acquisition!');
            error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Command']);
        end
    end
end

% -------------------------------------------------------------------%

% Equivalent to AT_Flush(Handle);
err = calllib('lib', 'AT_Flush', bench.andor.andor_handle);
if(err~=0)
    disp('Failed to flush buffer!');
    error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Flush']);
end

% -------------------------------------------------------------------%

try
    hcst_andor_setSensorCooling(bench,false,false);
catch
    disp('Cooler still on.');
end
err = calllib('lib', 'AT_Close', bench.andor.andor_handle);

if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Close']);
end

err = calllib('lib', 'AT_FinaliseLibrary');

if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_FinaliseLibrary']);
end

unloadlibrary lib;

disp('*** Andor Neo Camera disconnected. ***');

bench.andor.CONNECTED = false;

% Save backup bench object
hcst_backUpBench(bench)

end
