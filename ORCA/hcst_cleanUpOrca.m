function hcst_cleanUpOrca(bench)
%hcst_cleanUpOrca Function to closes the connection the Orca Quest Camera for control
%   
%   - This function should be called when finished with the Orca camera
%   - It uses dcam.py
%
%   Arguments/Outputs:
%   hcst_cleanUpOrca(bench) Closes the dcam control classes.
%       Updates the ORCA sub-struct which contains pertinent information
%       'bench' is the object containing all pertinent bench information and
%           instances. It is created by the hcst_config() function.
%
%
    disp('*** Cleaning up Orca Quest Camera ... ***')
    cam_isOpen = bench.orca.pyObj.dev_close();
    cam_isOpen2 = py.dcam.Dcamapi.uninit();
%     bench.orca.pyObj = Dcam(bench.orca.iDevice);

    % Confirm the FW is connected
    if(cam_isOpen && cam_isOpen2)
        bench.orca.CONNECTED = false;
        disp('*** Orca disconnected. ***')
    else
        disp('*** Orca failed to disconnect. ***')
    end
            
    % Save backup bench object
    hcst_backUpBench(bench)
    
end