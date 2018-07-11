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
    end
end

