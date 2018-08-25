classdef Bench < handle
    %BENCH Handle subclass to hold reference to bench struct
    %   Implements pass by refernece for bench struct.
    
    properties
        FPM
        LS
        TTM
        DM
        andor
        info
    end
    
    methods
        
        function Bench = Bench(FPM, LS, TTM, DM, andor, info)
            %BENCH Construct an instance of this class
            Bench.FPM = FPM;
            Bench.LS = LS;
            Bench.TTM = TTM;
            Bench.DM = DM;
            Bench.andor = andor;
            Bench.info = info;
        end
        
        function isConnected(bench)
            fields = fieldnames(bench);
            for idx = 1:numel(fields)
                if(any(strcmp({'FPM','LS','TTM','DM','andor'},fields{idx})))
                    fprintf("%s \t %s\n", string(fields{idx}), string(bench.(fields{idx}).CONNECTED))
                end
            end
        end
        
    end
end

