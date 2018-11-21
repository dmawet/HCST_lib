function hcst_cleanUpFPM(bench)
%hcst_cleanUpFPM Function to disconnect and cleanup the FPM 
%   
%   - This function uses the Conex.py class
%   - It closes the connections to the python serial objects and , if 
%       closed successfully, deletes the instances of the python Conex obj.
%
%
%   Inputs:
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpFPM(bench)
%           Closes serial ports and clears instances from bench.
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_setUpFPM
%

%% Close the connections and populate the result accordingly

bench.FPM.axV.close();
if ~bench.FPM.axV.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.FPM.axV, 'ser')
    % remove the instance of axis from bench
    bench.FPM = rmfield(bench.FPM, 'axV');
end

bench.FPM.axH.close();
if ~bench.FPM.axH.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.FPM.axH, 'ser')
    % remove the instance of axis from bench
    bench.FPM = rmfield(bench.FPM, 'axH');
end
    
bench.FPM.axF.close();
if ~bench.FPM.axF.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.FPM.axF, 'ser')
    % remove the instance of axis from bench
    bench.FPM = rmfield(bench.FPM, 'axF');
end

disp('*** FPM stages disconnected. ***');

bench.FPM.CONNECTED = false;

% Save backup bench object
hcst_backUpBench(bench)

end
