function hcst_cleanUpLS(B)
%hcst_cleanUpLS Function to disconnect and cleanup the LS
%   
%   - Uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   - It closes the connections to the MATLAB serial objects and , if 
%       closed successfully, deletes the instances of the Zaber objects
%
%
%   Arguments/Outputs:
%   hcst_cleanUpLS(B) closes connections to the Zabers
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpLS(B)
%           Closes serial ports and clears instances from B.bench.
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_setUpLS
%

%% Close the connections and populate the result accordingly

fclose(B.bench.LS.axV.Protocol.Port);
if strcmp(B.bench.LS.axV.Protocol.Port.Status, 'closed')
    %Axis closed successfully
    % delete serial object
    delete(B.bench.LS.axV.Protocol.Port)
    % remove the instance of axis from bench
    B.bench.LS = rmfield(B.bench.LS, 'axV');
end

% Close the second port if it's handle still exists
%   This is in case the two axes are not daisy chained
if B.bench.LS.axH.Protocol.Port.isvalid
    %Axis was not closed/deleted already
    fclose(B.bench.LS.axH.Protocol.Port);
    if strcmp(B.bench.LS.axH.Protocol.Port.Status, 'closed')
        %Axis closed successfully
        % delete serial object
        delete(B.bench.LS.axH.Protocol.Port)
        % remove the instance of axis from bench
        B.bench.LS = rmfield(B.bench.LS, 'axH');
    end
else
    % Axis is already closed/deleted
    % remove the instance of axis from bench
    B.bench.LS = rmfield(B.bench.LS, 'axH');
end

B.bench.LS.CONNECTED = false;

end
