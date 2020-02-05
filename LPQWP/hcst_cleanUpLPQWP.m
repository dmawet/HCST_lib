function hcst_cleanUpLPQWP(bench)
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

bench.LPQWP.axLP1.close();
if ~bench.LPQWP.axLP1.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.LPQWP.axLP1, 'ser')
    % remove the instance of axis from bench
    bench.LPQWP = rmfield(bench.LPQWP, 'axLP1');
end
bench.LPQWP.axQWP1.close();
if ~bench.LPQWP.axQWP1.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.LPQWP.axQWP1, 'ser')
    % remove the instance of axis from bench
    bench.LPQWP = rmfield(bench.LPQWP, 'axQWP1');
end
bench.LPQWP.axLP2.close();
if ~bench.LPQWP.axLP2.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.LPQWP.axLP2, 'ser')
    % remove the instance of axis from bench
    bench.LPQWP = rmfield(bench.LPQWP, 'axLP2');
end
bench.LPQWP.axQWP2.close();
if ~bench.LPQWP.axQWP2.ser.isOpen
    % Axis closed successfully
    % delete python serial object
    py.delattr(bench.LPQWP.axQWP2, 'ser')
    % remove the instance of axis from bench
    bench.LPQWP = rmfield(bench.LPQWP, 'axQWP2');
end
    
disp('*** LPQW stages disconnected. ***');

bench.LPQWP.CONNECTED = false;

% Save backup bench object
hcst_backUpBench(bench)

end
