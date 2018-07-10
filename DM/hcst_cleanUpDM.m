function hcst_cleanUpDM(B)
%bench = hcst_cleanUpDM(bench)
%Closes connection with the HCST BMC DM and cleans up
%   - This function should be called when finished running the BMC DM
%   - It uses the BMC libraries in /opt/Boston Micromachines/lib/Matlab/
%   
%
%   Arguments/Outputs:
%   bench = hcst_cleanUpDM(bench) 
%       Closes the BMC DM libraries libraries
%       Cleans the DM sub-struct from bench
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

% Zero the DM
try 
    hcst_DM_zeroDM( B );
catch
    disp('Could not zero the DM.');
end
% if(err_code~=0)
%     eString = BMCGetErrorString(err_code);
%     disp(eString);
% end

% Close the driver
err_code = BMCCloseDM(B.bench.DM.dm);
if(err_code~=0)
    eString = BMCGetErrorString(err_code);
    error(eString);
end

B.bench.DM.CONNECTED = 0;

disp('BMC DM disconnected. Clean up complete.');

end