function cmds = hcst_DM_applyCross_shifted( bench, cmd, shift )
% cmds = hcst_DM_applyCross( bench, cmd )


    flatvec = bench.DM.flatvec;
    
    NactAcross = 34;
    
    im = zeros(NactAcross);
    
    shiftx = shift(1);
    shifty = shift(2);
    centx = 17+shiftx;
    centy = 17+shifty;
    im(:,centx:(centx+1)) = 1;
    im(centy:(centy+1),:) = 1;
    
    data = cmd*hcst_DM_2Dto1D(bench,im);
    
    cmds = data+flatvec;
    
    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

