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

