function hcst_backUpBench(bench)
%hcst_backUpBench(bench) Saves current bench struct to bench.info.benchBackUpDir

    flnm = [bench.info.benchBackUpDir,...
        'bench',datestr(now,'yyyymmddTHHMMSS'),'.mat'];
    
%     savedbenchstruct = bench;
    
   savedbenchshtruct = Bench(bench.FPM, bench.LPQWP, bench.LS, bench.TTM, bench.DM,bench.orca, ...
       bench.andor, bench.FW, bench.NKT, bench.FIUstages, bench.BSzaber,bench.Analyzerzaber, bench.FEUzaber, ...
       bench.cameraZaber,bench.Femto,bench.FS, bench.CAMZ, bench.info );

    if isprop( bench, 'FEUzaber') 
%         savedbenchstruct.FEUzaber = [];
        savedbenchstruct.FEUzaber.conn = [];
        savedbenchstruct.FEUzaber.axis = [];
    end
    if isprop( bench, 'BSzaber') 
%         savedbenchstruct.FEUzaber = [];
        savedbenchstruct.BSzaber.conn = [];
        savedbenchstruct.BSzaber.axis = [];
    end
    if isprop( bench, 'Analyzerzaber') 
%         savedbenchstruct.FEUzaber = [];
        savedbenchstruct.Analyzerzaber.conn = [];
        savedbenchstruct.Analyzerzaber.axis = [];
    end
    
    save(flnm,'savedbenchstruct');

end

