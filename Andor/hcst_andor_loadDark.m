function dark = hcst_andor_loadDark(B,flnm)
%dark = hcst_andor_loadDark(bench,flnm)
%Loads a dark frame for the Andor Neo camera. 
%
%   - Loads a dark frame from 'flnm'.
%   - Crops the Andor Neo dark frame to a frame size of
%       'B.bench.andor.AOIWidth' centered at
%       (B.bench.andor.centerrow, B.bench.andor.centercol)
%
%   Inputs:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%       'flnm' - The full path to the file
%
%   Outputs:
%       'dark' - double array - cropped dark frame.

    dark = fitsread(flnm);
    [rows,cols] = size(dark);
    isNotFullFrame = or(B.bench.andor.AOIHeight~= rows,...
                     B.bench.andor.AOIWidth ~= cols);
	if(isNotFullFrame)

        if(B.bench.andor.AOIHeight~=bench.andor.AOIWidth)
            error('HCST currently only supports square, even sub-windows.')
        elseif(mod(B.bench.andor.AOIHeight,2)~=0)
            error('HCST currently only supports even sized sub-windows.');
        end
           
        centcol = B.bench.andor.centcol;
        centrow = B.bench.andor.centrow;
        cropsize = B.bench.andor.AOIHeight;

        croprows = centrow-cropsize/2+1:centrow+cropsize/2;
        cropcols = centcol-cropsize/2+1:centcol+cropsize/2;
        
        dark = dark(croprows,cropcols);
        
    end
end

