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
    if(bench.FS.CONNECTED)
       hcst_cleanUpFS(bench);
    end
    if(bench.LPQWP.CONNECTED)
       hcst_cleanUpLPQWP(bench);
    end
    % LS and Analyzer
    if(bench.LS.CONNECTED)
       hcst_cleanUpLS(bench);
    end
    if(bench.Analyzerzaber.CONNECTED)
       hcst_cleanUpAnalyzerzaber(bench);
    end
    %
    if(bench.FEUzaber.CONNECTED)
       hcst_cleanUpFEUzaber(bench);
    end
    if(bench.cameraZaber.CONNECTED)
       hcst_cleanUpCameraZaber(bench);
    end
    
    if(bench.BSzaber.CONNECTED)
       hcst_cleanUpBSzaber(bench);
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
