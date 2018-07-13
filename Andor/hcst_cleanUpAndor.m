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
%       hcst_setUpAndor(bench)
%           Updates 'bench', disconnects the andor
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

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

disp('Andor Neo Camera disconnected. Clean up complete.');

bench.andor.CONNECTED = false;

end
