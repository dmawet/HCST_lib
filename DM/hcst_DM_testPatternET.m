function cmds = hcst_DM_testPatternET( bench, cmd )
%cmds = hcst_DM_testPatternET( bench, cmd )


    flatvec = bench.DM.flatvec;
    
    
    im = round(rgb2gray(imread('ETmovieposter.jpg'))/255);
    croprows = 274:368;
    cropcols = 54:225;
    im = im(croprows,cropcols);
    im = bwareaopen(im, 500);

    % im = imresize(im,[26 26]);
    % im = padarray(im,[4 4]);
    im = imresize(im,[20 20]);
    im = padarray(im,[7 7]);
%     figure;imagesc(im);axis image;colorbar;title('Pattern sent.');

    data = cmd*hcst_DM_2Dto1D(bench,rot90(im));
    
    cmds = data+flatvec;
    
    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

