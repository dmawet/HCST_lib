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
    
    % Set trigger as software
    DCAMPROP = bench.orca.dcamapi4.DCAMPROP;
    
    %DCAMPROP.TRIGGERSOURCE.INTERNAL = 1 , use for single frames
    %DCAMPROP.TRIGGERSOURCE.SOFTWARE = 3 , use for batch frames
    bench.orca.triggersource = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.TRIGGERSOURCE, 1);%DCAMPROP.TRIGGERSOURCE.SOFTWARE);
    if bench.orca.triggersource == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end
    
    % Set trigger mode 
    % NORMAL = 1
    % PIV = 3
    % START = 6
    bench.orca.triggermode = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.TRIGGER_MODE, 1);
    if bench.orca.triggermode == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end

    bench.orca.firetrigger_cycle = 0;

    % Make sure TEC is on:
    %     OFF = 1
    %     ON = 2
    %     MAX = 4

    TEC_status = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.SENSORCOOLER, 2);
    if TEC_status == false || TEC_status == 1 
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA TEC ERROR:']);
    end
    disp('Detector temperature:')
    for i = 1:1:10
        temperature = bench.orca.pyObj.prop_getvalue(bench.orca.dcamapi4.DCAM_IDPROP.SENSORTEMPERATURE);
        disp(num2str(temperature))
    end

    % Get max and min subwindow sizes
    propattr_hsize = bench.orca.pyObj.prop_getattr(bench.orca.dcamapi4.DCAM_IDPROP.SUBARRAYHSIZE);
    propattr_vsize = bench.orca.pyObj.prop_getattr(bench.orca.dcamapi4.DCAM_IDPROP.SUBARRAYVSIZE);
    
    bench.orca.AOImin = min([propattr_hsize.valuemin, propattr_vsize.valuemin]);
    bench.orca.AOImax_h = propattr_hsize.valuemax; %min([propattr_hsize.valuemax, propattr_vsize.valuemax]); 
    bench.orca.AOImax_v = propattr_vsize.valuemax; 

    % Set subwindow to full image
    hcst_orca_setSubwindowFullframe(bench)

    % Set exposure time to default
    hcst_orca_setExposureTime(bench, bench.orca.default_tint)

    % Set binning to 1:
    new_binning = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.BINNING, uint16(1));

    if new_binning == false %|| ind == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
        bench.orca.binning = new_binning;
        disp(['Binning set to 1'])
    end 


%     hcst_orca_setSubwindow(bench, centerrow, centercol, framesize)
            
    % Save backup bench object
    hcst_backUpBench(bench)
    
end