function cmds = hcst_DM_pokeColumn( bench, cmd, column )
% cmds = hcst_DM_applyCross( bench, cmd )


    flatvec = bench.DM.flatvec;
    
    NactAcross = 34;
    
    im = zeros(NactAcross);
    im(:,column) = 1;
%     im(17:18,:) = 1;
    
    data = cmd*hcst_DM_2Dto1D(bench,im);
    
    cmds = data+flatvec;
    
    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

