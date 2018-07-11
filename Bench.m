classdef Bench < handle
    %BENCH Handle subclass to hold reference to bench struct
    %   Implements pass by refernece for bench struct.
    
    properties
        bench
    end
    
    methods
        function B = Bench(bench)
            %BENCH Construct an instance of this class
            B.bench = bench;
        end
        
        function isConnected(B)
            fields = fieldnames(B.bench);
            for idx = 1:numel(fields)
                fprintf("%s \t %s\n", string(fields{idx}), string(B.bench.(fields{idx}).CONNECTED))
            end
        end
    end
end

