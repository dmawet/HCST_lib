function hcst_orca_setSubwindow(bench, centerrow, centercol, framesize)
%hcst_orca_setSubwindow Changes the subwindow of the orca camera. Assumes the subwindow is a square with an even number of pixels. 
%
%   - Crops the Orca image to a frame size of 'framesize' centered at
%       (centerrow,centercol)
%   - Updates the 'bench' struct 
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'centerrow', 'centercol' - The pixel index in the full frame mode
%           of the pixel where the subwindow will be centered (starting
%           index is 1)
%       'framesize' - The size of the sub-window in pixels 
    verbose = true;

%     if(nargin>4)
%         verbose = varargin{1};
%     end

% 	The DCAM_IDPROP_SUBARRAYHPOS value plus the DCAM_IDPROP_SUBARRAYHSIZE 
%   value must be equal or smaller than the horizontal sensor size. And the 
%   DCAM_IDPROP_SUBARRAYVPOS value plus the DCAM_IDPROP_SUBARRAYVSIZE value 
%   must be equal or smaller than vertical sensor size. 

%     orca_handle = bench.orca.orca_handle;
    DCAM_IDPROP = bench.orca.dcamapi4.DCAM_IDPROP;

    % HSIZE, HPOS etc are in un-binned coords
    if bench.orca.binning ~= 1
        framesize = framesize * bench.orca.binning;
        centerrow = centerrow * bench.orca.binning;
        centercol = centercol * bench.orca.binning;
    end

    bench.orca.AOIWidth = framesize;
    bench.orca.AOIHeight = framesize;
    
    if strcmp(bench.orca.subwindow_shift, 'center')
        shift_subwindow_center(bench, centerrow, centercol, framesize)
    else
        shift_subwindow_topleft(bench, centerrow, centercol, framesize)
    end

    if(bench.orca.AOIHeight~=bench.orca.AOIWidth)
%         error('HCST currently only supports square, even sub-windows.')
        disp('Subwindow is not square.')
    elseif(mod(bench.orca.AOIHeight,4)~=0)
        error('HCST currently only supports sub-windows that are a factor of 4.');
    elseif(bench.orca.AOImin>bench.orca.AOIHeight || bench.orca.AOImax_v<(bench.orca.AOIHeight + centerrow)|| bench.orca.AOImax_h<(bench.orca.AOIWidth + centercol))
        error(['Orca subwindow must be between ', num2str(bench.orca.AOImin), ' and ', num2str(bench.orca.AOImax_h)]);
    end
    
    % Turn subarray off first, this might not be reqd
    subarr_onoff = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYMODE, bench.orca.dcamapi4.DCAMPROP.MODE.OFF);
    if subarr_onoff == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
        disp(['Subarray off ', num2str(subarr_onoff)])
    end 


    aoi_h = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.SUBARRAYHSIZE, uint16(bench.orca.framesize_hor));
    
    if aoi_h == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
%         bench.orca.AOIWidth = aoi_h;
        disp(['AOI width set to ', num2str(aoi_h)])
    end

    aoi_v = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.SUBARRAYVSIZE, uint16(bench.orca.framesize_ver));
    if aoi_v == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
%         bench.orca.AOIHeight = aoi_v;
        disp(['AOI height set to ', num2str(aoi_v)])
    end

    % For some reason this must be an multiple of 100
    aoi_hpos = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYHPOS, bench.orca.AOILeft);
    if aoi_hpos == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR']);
    else
        disp(['AOI left set to ', num2str(aoi_hpos)])
    end
    
    aoi_vpos = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYVPOS, bench.orca.AOITop);
    if aoi_vpos == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
        disp(['AOI top set to ', num2str(aoi_vpos)])
    end 
   
    subarr_onoff = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYMODE, bench.orca.dcamapi4.DCAMPROP.MODE.ON);
    if subarr_onoff == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
        disp(['Subarray on ', num2str(subarr_onoff)])
    end 
    
    bench.orca.subarr_onoff = true;

    % Adjust parameters to binning:
    if bench.orca.binning ~= 1
        bench.orca.AOIHeight = bench.orca.AOIHeight / bench.orca.binning;
        bench.orca.AOIWidth = bench.orca.AOIWidth / bench.orca.binning;
        bench.orca.centrow = bench.orca.centrow / bench.orca.binning;
        bench.orca.centcol = bench.orca.centcol / bench.orca.binning;
       
    end

    
    % hcst_orca_getImageFormatting(bench);
%     bench.orca.imSizeBytes = hcst_orca_getImageSizeBytes(bench);
    if verbose
        disp('orca Camera sub-window changed:');
%         disp(['     image size (bytes) = ',num2str(bench.orca.imSizeBytes)]);
        disp(['     AOIHeight = ',num2str(bench.orca.AOIHeight)]);
        disp(['     AOIWidth  = ',num2str(bench.orca.AOIWidth)]);
        disp(['     AOICenterRow = ',num2str(bench.orca.centrow)]);
        disp(['     AOICenterCol  = ',num2str(bench.orca.centcol)]);
%         disp(['     AOIStride = ',num2str(bench.orca.AOIStride)]);
    end
end

function shift_subwindow_center(bench, centerrow, centercol, framesize_orig)
    bench.orca.centcol = centercol; 
	bench.orca.centrow = centerrow;
    disp('left')
    [bench.orca.AOILeft, framesize] = get_new_sw_coords(centercol, framesize_orig, false);
    disp('top')
    [bench.orca.AOITop, framesize] = get_new_sw_coords(centerrow, framesize, false);

    disp(['AOI Left is ', num2str(bench.orca.AOILeft)])
    disp(['AOI Top is ', num2str(bench.orca.AOITop)])

    disp(['AOI Right is ', num2str(bench.orca.AOILeft+framesize)])
    disp(['AOI Bottom is ', num2str(bench.orca.AOITop +framesize)])
	
    bench.orca.AOIWidth = framesize;
    bench.orca.AOIHeight = framesize;

    if framesize ~= framesize_orig 
        disp('**Changing framesize to abide by ORCAs rules**')
        disp(['Framesize changed from ', num2str(framesize_orig), ' to ', num2str(framesize)])
    end
%     bench.orca.AOILeft =  get_shifted_aoi_coord(centercol, framesize);
%     bench.orca.AOITop = get_shifted_aoi_coord(centerrow, framesize);
	
end

function [top, framesize] = get_new_sw_coords(centercoord, framesize, col_tf)

framecheck=false;
for i = 1:1:10
    % Ensure framesize is a multiple of 4
    if mod(framesize, 4) ~= 0
        framesize_round = ceil(framesize / 4) * 4;  % Round framesize to nearest multiple of 4
    else
        framesize_round = framesize;
    end
    disp(['framsize ceil: ', num2str(framesize_round)])

    [top, framesize] = adjust_paramters4(centercoord, framesize_round, col_tf);
    
    if framesize_round == framesize
        disp('found soln')
        framecheck = true;
        break
    else 
        framesize = framesize + 8;
        disp(num2str(framesize))
    end
end


if ~framecheck
    error('could not find framesize and border coord to meet orca reqs')

end

end
function [top, framesize] = adjust_paramters4(centercoord, framesize, col_tf)
    if col_tf
        sign = -1;
    else
        sign = 0;
    end
    
    % Calculate the initial top based on centerrow and framesize
    top = centercoord - framesize / 2 + sign*1;
    
    % Ensure top is a multiple of 4
    if mod(top, 4) ~= 0
        % Adjust top to be a multiple of 4
        top = ceil(top / 4) * 4;
        
        % Recalculate framesize to maintain the correct relationship with top
        framesize = (centercoord - top) * 2;
    end
    
    % Display the adjusted values
    fprintf('Adjusted top: %d\n', top);
    fprintf('Adjusted framesize: %d\n', framesize);
end


function shift_subwindow_topleft(bench, centerrow, centercol, framesize)
    % Note AOI left and top always have to be multiples of 100, not sure
    % why
    bench.orca.AOILeft = floor((centercol - framesize/2)/4)*4;
    bench.orca.AOITop = floor((centerrow - framesize/2)/4)*4;
	
    bench.orca.aoi_centcol = bench.orca.AOILeft + framesize/2; % TODO: Update based on AOI calcs
	bench.orca.aoi_centrow = bench.orca.AOITop + framesize/2;

    bench.orca.centcol = centercol; 
	bench.orca.centrow = centerrow;

    bench.orca.framesize_hor = ceil((framesize + (centercol - framesize/2 - bench.orca.AOILeft))/4)*4;
    bench.orca.framesize_ver = ceil((framesize + (centerrow - framesize/2 - bench.orca.AOITop))/4)*4;

    % TODO: fix for binning
    bench.orca.crop_col = (centercol - framesize/2 - bench.orca.AOILeft) / bench.orca.binning;
    bench.orca.crop_row = (centerrow - framesize/2 - bench.orca.AOITop) / bench.orca.binning;
    

    if bench.orca.centcol ~= bench.orca.aoi_centcol || bench.orca.centrow ~= bench.orca.aoi_centrow 
        disp('**Shifting center row and column to abide by ORCAs rules**')
        disp(['AOI hardare center Row shifted from ', num2str(centerrow), ' to ', num2str(bench.orca.aoi_centrow )])
        disp(['AOI hardare center Col shifted from ', num2str(centercol), ' to ', num2str(bench.orca.aoi_centcol)])

        disp(['AOI hardare frame width shifted from ', num2str(framesize), ' to ', num2str(bench.orca.framesize_hor )])
        disp(['AOI hardare frame height shifted from ', num2str(framesize), ' to ', num2str(bench.orca.framesize_ver)])

        bench.orca.crop_software = true;
    end
end



% function [aoi_real, framesize_new] = get_shifted_aoi_coord(centercoord, framesize)
% 
% aoi_try = centercoord - framesize/2;
% 
% % If AOI is not a multiple of 100
% if mod(aoi_try, 100)
%     nearest_multiple_of_100 = round(aoi_try / 100) * 100;
%     
%     % Calculate the difference from the nearest multiple
%     difference = aoi_try - nearest_multiple_of_100;
%     
%     
%     if abs(difference) < 30
%         disp('small diff')
%         aoi_real = nearest_multiple_of_100;
%         framesize_new = framesize + 2*difference;
%     
%     else
%         disp('big diff')
%         % use floor since we are going top left
%         aoi_real = floor(aoi_try / 100) * 100;
%         difference = aoi_try - aoi_real;
%         framesize_new = framesize + 2*difference;
%     
%     end
% end
% end