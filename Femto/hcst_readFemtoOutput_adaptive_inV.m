%Read the Femto signal through the analog input on the Labjack, then return
%the value you get in V to the main program.

function [ V ] = hcst_readFemtoOutput_adaptive_inV(bench,numavg)

    V = hcst_readFemtoOutput_adaptive(bench,numavg);
    gain_set = log10(bench.Femto.gain)-4;
    V = V-bench.Femto.V_offset(gain_set);
    V = V/(bench.Femto.gainStep^gain_set);
end