function hcst_backUpBench(bench)
%hcst_backUpBench(bench) Saves current bench struct to bench.info.benchBackUpDir

    flnm = [bench.info.benchBackUpDir,...
        'bench',datestr(now,'yyyymmddTHHMMSS'),'.mat'];
    
    savedbenchstruct = bench;

    save(flnm,'savedbenchstruct');

end

