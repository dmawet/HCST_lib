function cmds = hcst_DM_apply2Dmap( B, map, scale )
% [bench,cmds] = hcst_DM_apply2Dmap( bench, cmd )


    flatvec = B.bench.DM.flatvec;
    offsetAct = B.bench.DM.offsetAct;
    NactAcross = B.bench.DM.NactAcross;
    NactAcrossBeam = B.bench.DM.NactAcrossBeam;
    
    map = imresize(map,[NactAcrossBeam+1,NactAcrossBeam+1]);
    pad0 = (NactAcross - NactAcrossBeam-1)/2;
    map = padarray(map,[pad0 pad0]);
    map = circshift(map,[offsetAct(2) offsetAct(1)]);
%     im = round(rgb2gray(imread('ETmovieposter.jpg'))/255);
%     croprows = 274:368;
%     cropcols = 54:225;
%     im = im(croprows,cropcols);
%     im = bwareaopen(im, 500);
% 
%     % im = imresize(im,[26 26]);
%     % im = padarray(im,[4 4]);
%     im = imresize(im,[20 20]);
%     im = padarray(im,[7 7]);
	figure(666);imagesc(map);axis image;colorbar;title('Pattern sent.');

    data = scale*hcst_DM_2Dto1D(bench,fliplr(map));
    
    cmds = data+flatvec;
    
    err_code = BMCSendData(B.bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

