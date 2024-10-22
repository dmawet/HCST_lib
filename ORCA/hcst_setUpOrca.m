function hcst_setUpOrca(bench)
%hcst_setUpOrca Function to prepare the Orca Quest Camera for control
%   
%   - This function should be called before calling any other Orca functions
%   - It uses dcam.py
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
    
%     bench.orca.pyobj_DCAM_IDPROP = py.dcamapi4.DCAM_IDPROP();
% can do this but it only sets one of the props
% bench.orca.pyobj_DCAM_IDPROP = py.dcamapi4.DCAM_IDPROP(py.int(4202784));

%     % Get max and min subwindow sizes
%     propattr_hsize = bench.orca.pyObj.prop_getattr(DCAM_IDPROP.SUBARRAYHSIZE);
%     propattr_vsize = bench.orca.pyObj.prop_getattr(DCAM_IDPROP.SUBARRAYVSIZE);
%     
%     bench.orca.AOImin = min([propattr_hsize.valuemin, propattr_vsize.valuemin]);
%     bench.orca.AOImax = max([propattr_hsize.valuemax, propattr_vsize.valuemax]); 
%             
    % Save backup bench object
    hcst_backUpBench(bench)
    
end