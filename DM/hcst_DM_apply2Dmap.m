function cmds = hcst_DM_apply2Dmap( bench, map, scale )
% cmds = hcst_DM_apply2Dmap( bench, map, scale )


    flatvec = bench.DM.flatvec;

    data = scale*hcst_DM_2Dto1D(bench,map);
    
    cmds = data+flatvec;
    
    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

