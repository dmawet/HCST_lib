function [lower,upper] = tb_NKT_getWvlRange(bench)
%[lower,upper] = tb_NKT_getWvlRange(bench) Get wavelength range of the NKT Varia.
%
%   Inputs:
%       'bench' - object containing all pertinent bench information
%           and instances. It is created by the tb_config() function.
%
%   Outputs:
%       'lower' - lower wavelength (nm)
%       'upper' - upper wavelength (nm)
%
%   author: G. Ruane
%   last modified: March 22, 2019

    % Get the current lower and upper wavelengths  
    lower = bench.NKT.nktobj.get_varia_lwpsetpoint();
    upper = bench.NKT.nktobj.get_varia_swpsetpoint();

    
    % % Save backup bench object
    % hcst_backUpBench(bench)

end
