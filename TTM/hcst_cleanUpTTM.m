function hcst_cleanUpTTM(B)
%hcst_cleanUpTTM Function to disconnect and cleanup the TTM 
%   
%   - This function uses the PI MATLAB driver
%   - It closes the connections to the PI Controller and , if closed 
%       successfully, deletes the instances of the PI control objects
%
%   - NOTE: THIS FUNCTION JUST CLOSES THE CONNECTION TO THE CONTROLLER
%       It does not: open the loop, 0 the voltage, or set the axes offline.
%       THESE ACTIONS ARE KNOWN TO CHANGE THE POSITION OF THE TTM
%       However, if you want to open the loop, 0 the voltage, and set the
%       axes offline (for example, to power-down the system) use:
%           hcst_TTM_fullShutDown.
%
%
%   Arguments/Outputs:
%   bench = hcst_cleanUpTTM(bench) closes connections to the PI Controller
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpTTM(bench)
%           Closes connections and clears instances from bench. Returns an
%           updated version of bench without the closed ports.
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_setUpTTM,
%               hcst_TTM_fullShutDown
%

%% Close the connections and populate the bench struct accordingly
B.bench.TTM.stage.PIdevice.CloseConnection;
B.bench.TTM.stage.Controller.Destroy;
if ~B.bench.TTM.stage.PIdevice.IsConnected
    % Remove the sub-struct only if successfully closed
    B.bench.TTM = rmfield(B.bench.TTM, 'stage');
    B.bench.TTM.CONNECTED = false;
end

end
