function dark = hcst_andor_loadDark(bench,flnm)
%hcst_andor_loadDark Loads a dark frame for the Andor Neo camera. 
%
%   - Loads a dark frame from 'flnm'.
%   - Crops the Andor Neo dark frame to a frame size of
%       'bench.andor.AOIWidth' centered at
%       (bench.andor.centerrow, bench.andor.centercol)
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'flnm' - The full path to the file
%
%   Outputs:
%       'dark' - double array - cropped dark frame.

    if ~isfile(flnm) && bench.NKT.CONNECTED
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         resPos = hcst_FEUzaber_move(bench,bench.FEUzaber.posIn);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        centcol = bench.andor.centcol;
        centrow = bench.andor.centrow;
        cropsize = bench.andor.AOIHeight;
        disp(['Taking darks: tint = ',num2str(bench.andor.tint),' sec']);
        hcst_andor_resetSubwindow(bench);
        pause(1)
        tb_NKT_setEmission(bench,false);
        
        %Take dark
        % Take three burner images
        for imnum = 1:3
            hcst_andor_getImage(bench);
        end
        darkcube = zeros(bench.andor.AOIHeight,bench.andor.AOIWidth,5);
        for imnum = 1:5
            darkcube(:,:,imnum) = hcst_andor_getImage(bench);
        end
        dark = median(darkcube,3);
        
        % Save dark
        hcst_andor_fitswrite(bench,dark,flnm,false)
        hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);
        tb_NKT_setEmission(bench,true);
        pause(1)
    end
 
    dark = fitsread(flnm);
    [rows,cols] = size(dark);
    isNotFullFrame = or(bench.andor.AOIHeight~= rows,...
                     bench.andor.AOIWidth ~= cols);
	if(isNotFullFrame)

        if(bench.andor.AOIHeight~=bench.andor.AOIWidth)
            error('HCST currently only supports square, even sub-windows.')
        elseif(mod(bench.andor.AOIHeight,2)~=0)
            error('HCST currently only supports even sized sub-windows.');
        end
           
        centcol = bench.andor.centcol;
        centrow = bench.andor.centrow;
        cropsize = bench.andor.AOIHeight;

        croprows = centrow-cropsize/2+1:centrow+cropsize/2;
        cropcols = centcol-cropsize/2+1:centcol+cropsize/2;
        
        dark = dark(croprows,cropcols);
        
    end
end

