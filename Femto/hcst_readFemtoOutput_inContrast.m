%hcst_readFemtoOutput_inV
function [ NI ] = hcst_readFemtoOutput_inContrast(bench,numavg)

    V = hcst_readFemtoOutput_adaptive(bench,numavg);
    gain_set = log10(bench.Femto.gain)-4;
    V = V-bench.Femto.V_offset(gain_set);
    V = V/(bench.Femto.gainStep^gain_set);
    NI = V/bench.Femto.V0_peak;
end       
