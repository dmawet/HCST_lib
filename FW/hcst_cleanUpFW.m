function hcst_cleanUpFW(bench)
%hcst_cleanUpFW Closes connection with the filter wheel (FW) and cleans up
%   - This function should be called when finished with the FW
%   - It uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:
%   hcst_cleanUpAndor(bench) 
%       Closes the connection with the FW
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpFW(bench)
%           Updates 'bench', disconnects the FW


hcst_FW_setPos(bench,bench.FW.defaultPos);

bench.FW.pyObj.close();


if(~bench.FW.pyObj.isOpen)
    bench.FW.CONNECTED = false;
    disp('Filter wheel disconnected. Clean up complete.');
else
    disp('Filter wheel failed to disconnect.');
end

% Save backup bench object
hcst_backUpBench(bench)

end
