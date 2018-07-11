function hcst_cleanUpFPM(B)
%hcst_cleanUpFPM Function to disconnect and cleanup the FPM 
%   
%   - This function uses the Conex.py class
%   - It closes the connections to the python serial objects and , if 
%       closed successfully, deletes the instances of the python Conex obj.
%
%
%   Inputs:
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpFPM(B)
%           Closes serial ports and clears instances from B.bench.
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_setUpFPM
%

%% Close the connections and populate the result accordingly

B.bench.FPM.axV.close();
if ~B.bench.FPM.axV.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(B.bench.FPM.axV, 'ser')
    % remove the instance of axis from bench
    B.bench.FPM = rmfield(B.bench.FPM, 'axV');
end

B.bench.FPM.axH.close();
if ~B.bench.FPM.axH.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(B.bench.FPM.axH, 'ser')
    % remove the instance of axis from bench
    B.bench.FPM = rmfield(B.bench.FPM, 'axH');
end
    
B.bench.FPM.axF.close();
if ~B.bench.FPM.axF.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(B.bench.FPM.axF, 'ser')
    % remove the instance of axis from bench
    B.bench.FPM = rmfield(B.bench.FPM, 'axF');
end

B.bench.FPM.CONNECTED = false;

end
