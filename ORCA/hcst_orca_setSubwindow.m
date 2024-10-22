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

%     orca_handle = bench.orca.orca_handle;
    DCAM_IDPROP = bench.orca.dcamapi4.DCAM_IDPROP;
    
    bench.orca.AOIWidth = framesize;
    bench.orca.AOIHeight = framesize;
    bench.orca.AOILeft = floor((centercol - framesize/2 - 1)/100)*100;
    bench.orca.AOITop = floor((centerrow - framesize/2 - 1)/100)*100;
	bench.orca.centcol = centercol;
	bench.orca.centrow = centerrow;
    
    if(bench.orca.AOIHeight~=bench.orca.AOIWidth)
        error('HCST currently only supports square, even sub-windows.')
    elseif(mod(bench.orca.AOIHeight,2)~=0)
        error('HCST currently only supports even sized sub-windows.');
    elseif(bench.orca.AOImin>bench.orca.AOIHeight || bench.orca.AOImax<bench.orca.AOIHeight)
        error(['Orca subwindow must be between ', num2str(bench.orca.AOImin), ' and ', num2str(bench.orca.AOImax)]);
    end
    

    aoi_h = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYHSIZE, bench.orca.AOIWidth);
    if aoi_h == false
        error(['HCST_lib ORCA ERROR:',bench.orca.pyObj.lasterr()]);
    else
        disp(['AOI width set to ', num2str(aoi_h)])
    end

    aoi_v = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYVSIZE, bench.orca.AOIHeight);
    if aoi_v == false
        error(['HCST_lib ORCA ERROR:',bench.orca.pyObj.lasterr()]);
    else
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
        error(['HCST_lib ORCA ERROR:',bench.orca.pyObj.lasterr()]);
    else
        disp(['AOI top set to ', num2str(aoi_vpos)])
    end 
   
    subarr_onoff = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYMODE, bench.orca.dcamapi4.DCAMPROP.MODE.ON);
    if subarr_onoff == false
        error(['HCST_lib ORCA ERROR:',bench.orca.pyObj.lasterr()]);
    else
        disp(['Subarray on ', num2str(subarr_onoff)])
    end 

    
%     hcst_orca_getImageFormatting(bench);
%     bench.orca.imSizeBytes = hcst_orca_getImageSizeBytes(bench);
    if verbose
        disp('orca Camera sub-window changed:');
%         disp(['     image size (bytes) = ',num2str(bench.orca.imSizeBytes)]);
        disp(['     AOIHeight = ',num2str(bench.orca.AOIHeight)]);
        disp(['     AOIWidth  = ',num2str(bench.orca.AOIWidth)]);
%         disp(['     AOIStride = ',num2str(bench.orca.AOIStride)]);
    end
end

