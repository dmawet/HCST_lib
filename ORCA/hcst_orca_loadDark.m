function dark = hcst_orca_loadDark(bench,flnm)
% TODO: TEST

%hcst_orca_loadDark Loads a dark frame for the Orca Quest camera. 
%
%   - Loads a dark frame from 'flnm'.
%   - Crops the Orca Quest dark frame to a frame size of
%       'bench.orca.AOIWidth' centered at
%       (bench.orca.centerrow, bench.orca.centercol)
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
        centcol = bench.orca.centcol;
        centrow = bench.orca.centrow;
        cropsize = bench.orca.AOIHeight;
        disp(['Taking darks: tint = ',num2str(bench.orca.tint),' sec']);
        hcst_orca_resetSubwindow(bench);
        pause(1)
        tb_NKT_setEmission(bench,false);
        
        %Take dark
        % Take three burner images
        for imnum = 1:3
            hcst_orca_getImage(bench);
        end
        darkcube = zeros(bench.orca.AOIHeight,bench.orca.AOIWidth,5);
        for imnum = 1:5
            darkcube(:,:,imnum) = hcst_orca_getImage(bench);
        end
        dark = median(darkcube,3);
        
        % Save dark
        hcst_orca_fitswrite(bench,dark,flnm,false)
        hcst_orca_setSubwindow(bench,centrow,centcol,cropsize);
        tb_NKT_setEmission(bench,true);
        pause(1)
    end
 
    dark = fitsread(flnm);
    [rows,cols] = size(dark);
    isNotFullFrame = or(bench.orca.AOIHeight~= rows,...
                     bench.orca.AOIWidth ~= cols);
	if(isNotFullFrame)

        if(bench.orca.AOIHeight~=bench.orca.AOIWidth)
            error('HCST currently only supports square, even sub-windows.')
        elseif(mod(bench.orca.AOIHeight,2)~=0)
            error('HCST currently only supports even sized sub-windows.');
        end
           
        centcol = bench.orca.centcol;
        centrow = bench.orca.centrow;
        cropsize = bench.orca.AOIHeight;

        croprows = centrow-cropsize/2+1:centrow+cropsize/2;
        cropcols = centcol-cropsize/2+1:centcol+cropsize/2;
        
        dark = dark(croprows,cropcols);
        
    end
end