classdef Bench < handle
    %BENCH Handle subclass to hold reference to bench struct
    %   Implements pass by refernece for bench struct.
    
    properties
        FPM
        LPQWP
        LS
        TTM
        DM
        andor
        FW
        NKT
        FIUstages
        BSzaber
        Analyzerzaber
        FEUzaber
        cameraZaber
        Femto
        FS
        CAMZ
        info
    end
    
    methods
        
        function Bench = Bench(FPM, LPQWP, LS, TTM, DM, andor, FW, NKT, FIUstages, BSzaber, Analyzerzaber, FEUzaber,cameraZaber, Femto,FS, CAMZ, info)
            %BENCH Construct an instance of this class
            Bench.FPM = FPM;
            Bench.LPQWP = LPQWP;
            Bench.LS = LS;
            Bench.TTM = TTM;
            Bench.DM = DM;
            Bench.andor = andor;
            Bench.FW = FW;
            Bench.NKT = NKT;
            Bench.FIUstages = FIUstages;
            Bench.BSzaber = BSzaber;
            Bench.Analyzerzaber = Analyzerzaber;
            Bench.FEUzaber = FEUzaber;
            Bench.cameraZaber = cameraZaber;
            Bench.Femto = Femto;
            Bench.FS = FS;
            Bench.CAMZ = CAMZ;
            Bench.info = info;
        end
        
        function isConnected(bench)
            fields = fieldnames(bench);
            for idx = 1:numel(fields)
                if(any(strcmp({'FPM','LS','TTM','DM','andor','FW','NKT','FIUstages','BSzaber','Analyzerzaber','FEUzaber','cameraZaber','FS', 'CAMZ'},fields{idx})))
                    fprintf("%s \t %s\n", string(fields{idx}), string(bench.(fields{idx}).CONNECTED))
                end
            end
        end
        
    end
end

