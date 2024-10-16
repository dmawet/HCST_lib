function hcst_cleanUpAnalyzerzaber(bench)
%hcst_cleanUpLS Function to disconnect and cleanup the LS
%   
%   - Uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   - It closes the connections to the MATLAB serial objects and , if 
%       closed successfully, deletes the instances of the Zaber objects
%
%
%   Arguments/Outputs:
%   hcst_cleanUpLS(bench) closes connections to the Zabers
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpLS(bench)
%           Closes serial ports and clears instances from B.bench.
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_setUpLS
%

%% Close the connections and populate the result accordingly

try
    bench.Analyzerzaber.conn.close();
catch
end

bench.Analyzerzaber.CONNECTED = false;

disp('*** Zaber stage for Analyzerzaber disconnected. ***');

% Save backup bench object
% hcst_backUpBench(bench)

end
