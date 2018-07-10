function data = hcst_DM_flattenDM_BMCmap( B, apply )
%[bench, data] = hcst_DM_flattenDM( bench, apply )
%Returns array of voltages data that provide a flat DM surface. With apply=true,
%this function also flattens the DM. 
% Set apply=true to apply voltages to DM. apply=false returns the
% volatages.
%   Uses voltage map provided by BMC: C25CW005#040_CLOSED_LOOP.mat
%   author: G. Ruane
%   last modified: May 21,2018

    temp=load('C25CW005#040_CLOSED_LOOP.mat');
    
    data = zeros(1,B.bench.DM.cmdLength);
    
    data(1:B.bench.DM.dm.size) = (temp.voltage_map_min(1:B.bench.DM.dm.size)/B.bench.DM.MAX_V)';
    
    if(apply)
        err_code = BMCSendData(B.bench.DM.dm, data);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    end
    
end

