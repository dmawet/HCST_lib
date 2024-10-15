%Read the Femto signal through the analog input on the Labjack, then return
%the value you get in V to the main program.
%
% v adaptive: Jorge Llop - Feb 9, 2020

function [ V ] = hcst_readFemtoOutput_adaptive(bench,numavg)
    
    while 1
        V0 = py.labjack.ljm.eReadName(bench.Femto.LJ.handle, "AIN0");
        gain = log10(bench.Femto.gain);
        if V0>9.7 % IF signal is too high for this gain setting
            if gain==5
                break;
            else
                G = hcst_setFemtoGain(bench,gain-1);
                pause(bench.Femto.waitTimeAfterGainChange)
            end
        elseif V0<bench.Femto.V_offset(gain-4)*3 % IF signal is lower than 3 times the noise offset for this gain setting
            if gain==11
                break
            else
                G = hcst_setFemtoGain(bench,gain+1);
                pause(bench.Femto.waitTimeAfterGainChange)
            end
        else
            break
        end
    end
    if(gain==11 && numavg<bench.Femto.min_averageNumReads); numavg = bench.Femto.min_averageNumReads;end
    V = hcst_readFemtoOutput_avgd(bench,numavg);
end