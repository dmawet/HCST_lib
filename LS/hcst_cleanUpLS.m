function hcst_cleanUpLS(bench)
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

fclose(bench.LS.axV.Protocol.Port);
if strcmp(bench.LS.axV.Protocol.Port.Status, 'closed')
    %Axis closed successfully
    % delete serial object
    delete(bench.LS.axV.Protocol.Port)
    % remove the instance of axis from bench
    bench.LS = rmfield(bench.LS, 'axV');
end

% Close the second port if it's handle still exists
%   This is in case the two axes are not daisy chained
if bench.LS.axH.Protocol.Port.isvalid
    %Axis was not closed/deleted already
    fclose(bench.LS.axH.Protocol.Port);
    if strcmp(bench.LS.axH.Protocol.Port.Status, 'closed')
        %Axis closed successfully
        % delete serial object
        delete(bench.LS.axH.Protocol.Port)
        % remove the instance of axis from bench
        bench.LS = rmfield(bench.LS, 'axH');
    end
else
    % Axis is already closed/deleted
    % remove the instance of axis from bench
    bench.LS = rmfield(bench.LS, 'axH');
end

bench.LS.CONNECTED = false;

% Save backup bench object
hcst_backUpBench(bench)

end
