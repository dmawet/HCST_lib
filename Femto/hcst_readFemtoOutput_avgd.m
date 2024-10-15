%Read the Femto signal through the analog input on the Labjack, then return
%the value you get in V to the main program.
%
% v adaptive: Jorge Llop - Feb 9, 2020

function [ V ] = hcst_readFemtoOutput_avgd(bench,numavg)
    
    V_arr = zeros(1,numavg);
    for II=1:numavg
        V_arr(II) = py.labjack.ljm.eReadName(bench.Femto.LJ.handle, "AIN0");
    end
    V = median(V_arr);
%     V = mean(V_arr);
end