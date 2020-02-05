% hcst_disconnectDevices
%
% Disconnect all devices. With options for nkt and DM
%
% Jorge Llop - 
function [] = hcst_disconnectDevices(bench, nkt, onlyDM)

if onlyDM
    if(bench.DM.CONNECTED)
        hcst_DM_zeroDM( bench );
        hcst_cleanUpDM(bench);
    end
else
    if(bench.andor.CONNECTED)
        hcst_cleanUpAndor(bench);
    end

    if(bench.FPM.CONNECTED)
       hcst_cleanUpFPM(bench);
    end
    if(bench.LPQWP.CONNECTED)
       hcst_cleanUpLPQWP(bench);
    end
    if(bench.LS.CONNECTED)
       hcst_cleanUpLS(bench);
    end
    if(bench.BS.CONNECTED)
       hcst_cleanUpBS(bench);
    end
    if nkt
        if(bench.NKT.CONNECTED)
            tb_NKT_setEmission(bench,false)
            tb_cleanUpNKT(bench);
        end
    end
    if(bench.FW.CONNECTED)
        hcst_cleanUpFW(bench);
    end
    if(bench.FIUstages.CONNECTED)
        hcst_PIStage_cleanUp(bench);
    end
    if(bench.Femto.CONNECTED)
        hcst_cleanUpFemto(bench);
    end

    if(bench.DM.CONNECTED)
        hcst_DM_zeroDM( bench );
        hcst_cleanUpDM(bench);
    end
end
end
