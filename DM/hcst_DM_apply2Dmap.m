function cmds = hcst_DM_apply2Dmap( bench, map, scale )
% cmds = hcst_DM_apply2Dmap( bench, map, scale )


    flatvec = bench.DM.flatvec;
    
%     map = fliplr(map);
%     map = rot90(map',1);
    
    data = scale*hcst_DM_2Dto1D(bench,map);
    
    cmds = data+flatvec;
    
    
    cmds(isnan(cmds)) = 0;
    if(nnz(cmds<=-1)>0)
        error('Cmds are less than -1');
    end
    
    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

