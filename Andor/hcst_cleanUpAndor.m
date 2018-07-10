function hcst_cleanUpAndor(B)
%bench = hcst_cleanUpAndor(bench)
%Closes connection with the Andor Neo and cleans up
%   - This function should be called when finished funning the Andor Neo
%   functions
%   - It uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Arguments/Outputs:
%   bench = hcst_cleanUpAndor(bench) 
%       Closes the Andor Neo libraries
%       Cleans the andor sub-struct from bench
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpAndor(bench)
%           Updates 'bench', removes the andor sub-struct
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

try
    hcst_andor_setSensorCooling(B,false,false);
catch
    disp('Cooler still on.');
end
err = calllib('lib', 'AT_Close', B.bench.andor.andor_handle);

if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Close']);
end

err = calllib('lib', 'AT_FinaliseLibrary');

if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_FinaliseLibrary']);
end

unloadlibrary lib;

disp('Andor Neo Camera disconnected. Clean up complete.');

B.bench.andor.CONNNECTED = false;

end
