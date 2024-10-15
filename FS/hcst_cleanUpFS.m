function hcst_cleanUpFS(bench)
%hcst_cleanUpFS Function to disconnect and cleanup the FS 
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
%       hcst_cleanUpFS(bench)
%           Closes serial ports and clears instances from bench.
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_setUpFS
%

%% Close the connections and populate the result accordingly

bench.FS.axV.close();
if ~bench.FS.axV.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.FS.axV, 'ser')
    % remove the instance of axis from bench
    bench.FS = rmfield(bench.FS, 'axV');
end

bench.FS.axH.close();
if ~bench.FS.axH.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.FS.axH, 'ser')
    % remove the instance of axis from bench
    bench.FS = rmfield(bench.FS, 'axH');
end
    
bench.FS.axF.close();
if ~bench.FS.axF.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.FS.axF, 'ser')
    % remove the instance of axis from bench
    bench.FS = rmfield(bench.FS, 'axF');
end

disp('*** FS stages disconnected. ***');

bench.FS.CONNECTED = false;

% Save backup bench object
hcst_backUpBench(bench)

end
