function tb_cleanUpNKT(bench)
%tb_cleanUpNKT(bench) Clearn up the NKT superK and varia. Updates the NKT
%sub-struct.
%
%   Inputs:
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the tb_config() function.
%
%   author: G. Ruane
%   last modified: March 22, 2019


    % Close the Nkt object
    bench.NKT.nktobj.close();

    % remove the connection object from the bench.NKT struct
    bench.NKT = rmfield(bench.NKT,'nktobj');

    bench.NKT.CONNECTED = false;

    disp('*** NKT disconnected. ***');

    % % Save backup bench object
    % hcst_backUpBench(bench)

end
