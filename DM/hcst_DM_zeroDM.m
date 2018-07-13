function hcst_DM_zeroDM( bench )
%cst_DM_zeroDM( bench )
%Sets BMC kilo DM voltages to zero.
%
%   author: G. Ruane
%   last modified: July 13, 2018



    err_code = BMCSendData(bench.DM.dm, zeros(1,bench.DM.cmdLength));
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end


end

