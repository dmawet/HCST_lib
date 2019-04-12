function tb_NKT_setPowerLevel(bench,powerlevel)
%tb_NKT_setPowerLevel(bench,powerlevel) Set power of the NKT SuperK.
%
%   Inputs:
%       'bench' - object containing all pertinent bench information
%           and instances. It is created by the tb_config() function.
%       'powerlevel' - power level setting (0-100)
%
%   author: G. Ruane
%   last modified: March 22, 2019

    bench.NKT.nktobj.set_powerlevel(powerlevel);
    tb_NKT_getPowerLevel(bench);

    % % Save backup bench object
    % hcst_backUpBench(bench)

end
