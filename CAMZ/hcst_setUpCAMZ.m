function hcst_setUpCAMZ(bench)
%hcst_setUpCAMZ Function to prepare the CAMZ for control
%   
%   - This function should be called before calling any other CAMZ functions
%   - It uses the core.py class

%   Arguments/Outputs:
%   hcst_setUpCAMZ(bench) Instantiates the KPC control classes.
%       Updates the CAMZ sub-struct which contains pertient information 
%       about the stage as well as the instances of the core.py class. 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpCAMZ(bench)
%           Updates 'bench', the CAMZ sub-struct, and the requisite classes
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpCAMZ
%

disp('*** Setting up CAMZ stage... ***');

%% Add the directory with all our libraries to the Python search path
HCST_lib_PATH = '/home/hcst/HCST_lib/CAMZ/pyKDC101/src/pyKDC101';
if count(py.sys.path, HCST_lib_PATH) == 0
    insert(py.sys.path, int32(0), HCST_lib_PATH);
end

bench.CAMZ.pyObj = py.core.KDC(SN=bench.CAMZ.serialNumber);

% Confirm the CAMZ is connected
if bench.CAMZ.pyObj.port_is_open()

    bench.CAMZ.CONNECTED = true;
    disp('*** CAMZ initialized. ***')
end

% Save backup bench object
% hcst_backUpBench(bench)

end

