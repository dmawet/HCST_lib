function hcst_setUpFW(bench)
%hcst_setUpFW Function to prepare the filter wheel (FW) for control
%   
%   - This function should be called before calling any other FW functions
%   - It uses fw102c.py
%
%   Arguments/Outputs:
%   hcst_setUpFW(bench) Instantiates the FW102C control classes.
%       Updates the FW sub-struct which contains pertinent information
%       'bench' is the object containing all pertinent bench information and
%           instances. It is created by the hcst_config() function.
%
%
    disp('*** Setting up filter wheel ... ***')
    % set the python path
    HCST_lib_PATH = '/home/hcst/HCST_lib/FW';
    if count(py.sys.path, HCST_lib_PATH) == 0
        insert(py.sys.path, int32(0), HCST_lib_PATH);
    end

    import fw102c.*

    bench.FW.pyObj = py.fw102c_py3.FW102C();

    % Confirm the FW is connected
    if(bench.FW.pyObj.isOpen)
        bench.FW.CONNECTED = true;
        disp('*** FW initialized. ***')
    end
        
    hcst_FW_setPos(bench,bench.FW.defaultPos);
    
    % Save backup bench object
    hcst_backUpBench(bench)
    
end

