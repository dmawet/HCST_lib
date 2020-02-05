%Read the Femto signal through the analog input on the Labjack, then return
%the value you get in V to the main program.

function [ V ] = hcst_readFemtoOutput_inV(bench,numavg)

    gain_set = log10(bench.Femto.gain)-5;
    % bench.Femto.V = py.labjack.ljm.eReadName(bench.Femto.LJ.handle, "AIN0");
    V_arr = zeros(1,numavg);
    for II=1:numavg
        V_arr(II) = py.labjack.ljm.eReadName(bench.Femto.LJ.handle, "AIN0");
    end
    V = mean(V_arr);
    V = V/(bench.Femto.gainStep^gain_set);
end