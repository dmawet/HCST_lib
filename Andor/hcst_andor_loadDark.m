function dark = hcst_andor_loadDark(bench,flnm)
%dark = hcst_andor_loadDark(bench,flnm)
%Loads a dark frame for the Andor Neo camera. 
%
%   - Crops the Andor Neo image to a frame size of 'framesize' centered at
%   (centerrow,centercol)

%   Inputs:   
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%       'flnm' - The full path to the file

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

