function hcst_DM_zeroDM( B )
%bench = hcst_DM_zeroDM( bench )
%Sets BMC kilo DM voltages to zero.
%
%   author: G. Ruane
%   last modified: May 21,2018



    err_code = BMCSendData(B.bench.DM.dm, zeros(1,B.bench.DM.cmdLength));
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end


end

