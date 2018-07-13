function hcst_cleanUpDM(bench)
%bench = hcst_cleanUpDM(bench)
%Closes connection with the HCST BMC DM and cleans up
%   - This function should be called when finished running the BMC DM
%   - It uses the BMC libraries in /opt/Boston Micromachines/lib/Matlab/
%   
%
%   Arguments/Outputs:
%   hcst_cleanUpDM(bench) 
%       Closes the BMC DM libraries libraries
%       Cleans the DM sub-struct from bench
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

% Zero the DM
try 
    hcst_DM_zeroDM( bench );
catch
    disp('Could not zero the DM.');
end
% if(err_code~=0)
%     eString = BMCGetErrorString(err_code);
%     disp(eString);
% end

% Close the driver
err_code = BMCCloseDM(bench.DM.dm);
if(err_code~=0)
    eString = BMCGetErrorString(err_code);
    error(eString);
end

bench.DM.CONNECTED = 0;

disp('BMC DM disconnected. Clean up complete.');

end