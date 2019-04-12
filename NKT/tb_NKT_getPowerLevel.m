function lvl = tb_NKT_getPowerLevel(bench)
%lvl = tb_NKT_getPowerLevel(bench) Get power level of the NKT SuperK.
%
%   Inputs:
%       'bench' - object containing all pertinent bench information
%           and instances. It is created by the tb_config() function.
%   Outputs:
%       'lvl' - power level setting (0-100)
%
%   author: G. Ruane
%   last modified: March 22, 2019

    lvl = bench.NKT.nktobj.get_powerlevel();
    
    disp(['NKT emission = ',num2str(lvl)]);

    % % Save backup bench object
    % hcst_backUpBench(bench)

end
