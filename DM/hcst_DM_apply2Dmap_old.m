function cmds = hcst_DM_apply2Dmap( bench, map, scale )
% cmds = hcst_DM_apply2Dmap( bench, map, scale )


    flatvec = bench.DM.flatvec;
    offsetAct = bench.DM.offsetAct;
    NactAcross = bench.DM.NactAcross;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    
    map = imresize(map,[NactAcrossBeam+1,NactAcrossBeam+1]);
    pad0 = (NactAcross - NactAcrossBeam-1)/2;
    map = padarray(map,[pad0 pad0]);
    map = circshift(map,[offsetAct(2) offsetAct(1)]);

	figure(666);imagesc(map);axis image;colorbar;title('Pattern sent.');
    set(gca,'ydir','normal');
    data = scale*hcst_DM_2Dto1D(bench,map);
    
    cmds = data+flatvec;
    
    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

