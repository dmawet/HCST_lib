function tb_setUpNKT(bench)
%tb_setUpNKT(bench) Set up the NKT super K and varia. Updates the NKT sub-struct 
% which contains pertient information.
%
%   Inputs:
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the tb_config() function.
%
%   author: G. Ruane
%   last modified: March 22, 2019

    if(~bench.NKT.CONNECTED)
        
        NKT_lib_PATH = bench.info.NKT_lib_PATH;
        if count(py.sys.path, NKT_lib_PATH) == 0
            insert(py.sys.path, int32(0), NKT_lib_PATH);
        end

        disp('*** Connecting to NKT ... ***');

        % Create Nkt object using nkt_mod.py
        bench.NKT.nktobj = py.nkt_mod_falco.Nkt('/dev/ttyNKT',115200);%115200%

        bench.NKT.CONNECTED = true;
        
        disp('*** NKT connected. ***');
    else
        
        disp('*** NKT already connected. ***');
        
    end

    

    % % Save backup bench object
    % hcst_backUpBench(bench)

end
