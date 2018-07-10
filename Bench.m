classdef Bench < handle
    %BENCH: Handle subclass to hold reference to bench struct
    %   Detailed explanation goes here
    
    properties
        bench
    end
    
    methods
        function b = Bench(bench)
            %BENCH: Construct an instance of this class
            %   Detailed explanation goes here
            b.bench = bench;
        end
    end
end

