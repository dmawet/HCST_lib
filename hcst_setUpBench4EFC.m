% Prepares bench to run speckle nulling 
% flagNKT: for the Supercontinuum Whitelight Source NKT VARIA+EXTREME
function hcst_setUpBench4EFC(flagDM,flagNKT,flagLS)
if(~exist('bench','var'))
    addpath('/home/hcst/HCST_lib')
	bench = hcst_config();
end

if(~bench.andor.CONNECTED)
	hcst_setUpAndor(bench,false);
end

if(~bench.FPM.CONNECTED)
    hcst_setUpFPM(bench);
end

if(~bench.LPQWP.CONNECTED)
    hcst_setUpLPQWP(bench);
end
if flagLS
    if(~bench.LS.CONNECTED)
       hcst_setUpLS(bench);
    end
end
%if(~bench.BS.CONNECTED)
%    hcst_setUpBS(bench);
%end

if flagNKT
    if(~bench.NKT.CONNECTED)
        tb_setUpNKT(bench);
        tb_NKT_setEmission(bench,true)
    end
end
if(~bench.FW.CONNECTED)
    hcst_setUpFW(bench);
end

if(~bench.FIUstages.CONNECTED)
    hcst_E873Controller_init(bench);
end

if(~bench.Femto.CONNECTED)
    hcst_setUpFemto(bench);
end

if flagDM
    if(~bench.DM.CONNECTED)
        hcst_setUpDM(bench);
    end
end

hcst_backUpBench(bench)

end
% hcst_andor_setSubwindow(bench,bench.andor.FocusRow,bench.andor.FocusCol,frameSize);
