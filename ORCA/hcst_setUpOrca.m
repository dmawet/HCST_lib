function hcst_setUpOrca(bench)
%hcst_setUpOrca Function to prepare the Orca Quest Camera for control
%   
%   - This function should be called before calling any other Orca functions
%   - It uses dcam.py and dcamapi4.py.
%   - orca.pyObj is the main python class that runs the camera
%   - orca.dcamapi4 is the imported module from dcamapi4, the API is
%   written weird in python so all the classes (that should be
%   dictionaries) need to be imported via py.importlib. dcamapi4 contains
%   all of the attribute information.
%
%   Arguments/Outputs:
%   hcst_setUpOrca(bench) Instantiates the dcam control classes.
%       Updates the ORCA sub-struct which contains pertinent information
%       'bench' is the object containing all pertinent bench information and
%           instances. It is created by the hcst_config() function.
%
%
    disp('*** Setting up Orca Quest Camera ... ***')
    % set the python path
    HCST_lib_PATH = '/home/hcst/HCST_lib/ORCA/dcamsdk4/samples/python/';
    if count(py.sys.path, HCST_lib_PATH) == 0
        insert(py.sys.path, int32(0), HCST_lib_PATH);
    end

    bench.orca.Dcamapi = py.dcam.Dcamapi.init();
    bench.orca.pyObj = py.dcam.Dcam(int32(bench.orca.iDevice));
    cam_isOpen = bench.orca.pyObj.dev_open();

    % Confirm the Orca is connected
    if(cam_isOpen)
        bench.orca.CONNECTED = true;
        disp('*** Orca initialized. ***')
    end

    bench.orca.dcamapi4 = py.importlib.import_module('dcamapi4');
    
    % Get max and min subwindow sizes
    propattr_hsize = bench.orca.pyObj.prop_getattr(bench.orca.dcamapi4.DCAM_IDPROP.SUBARRAYHSIZE);
    propattr_vsize = bench.orca.pyObj.prop_getattr(bench.orca.dcamapi4.DCAM_IDPROP.SUBARRAYVSIZE);
    
    bench.orca.AOImin = min([propattr_hsize.valuemin, propattr_vsize.valuemin]);
    bench.orca.AOImax = min([propattr_hsize.valuemax, propattr_vsize.valuemax]); 
            
    % Save backup bench object
    hcst_backUpBench(bench)
    
end