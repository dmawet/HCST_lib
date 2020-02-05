%Read the Femto signal through the analog input on the Labjack, then return
%the value you get in V to the main program.

function [ V ] = hcst_readFemtoOutput(bench)

% bench.Femto.V = py.labjack.ljm.eReadName(bench.Femto.LJ.handle, "AIN0");
V = py.labjack.ljm.eReadName(bench.Femto.LJ.handle, "AIN0");

end