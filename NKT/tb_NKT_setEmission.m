function tb_NKT_setEmission(bench,on_off)
%tb_NKT_setEmission(bench,on_off) Toggle emission of the NKT SuperK.
%
%   Inputs:
%       'bench' - object containing all pertinent bench information
%           and instances. It is created by the tb_config() function.
%       'on_off' -  true: sets emission to on
%                   false: sets emission to off
%
%   author: G. Ruane
%   last modified: March 22, 2019

    emsn = bench.NKT.nktobj.get_emission();

    trial = 1;
    % The NKT sometimes needs to be pinged a few times before it responds
    while(and(on_off ~= emsn,trial<=bench.NKT.numTries))
        ret = bench.NKT.nktobj.set_emission(on_off);
        emsn = bench.NKT.nktobj.get_emission();
        pause(bench.NKT.delay);
        trial = trial + 1;
    end
    
    stringoptions = {'off','on'};
    disp(['     NKT emission = ',stringoptions{emsn+1}]);

    % % Save backup bench object
    % hcst_backUpBench(bench)

end
