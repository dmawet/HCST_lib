function hcst_orca_setSubwindowFullframe(bench)
%hcst_orca_setSubwindow turns off subwindow for the orca camera.
%
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
    
    subarr_onoff = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYMODE, bench.orca.dcamapi4.DCAMPROP.MODE.OFF);
    if subarr_onoff == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
        disp(['Subarray off ', num2str(subarr_onoff)])
    end 

    
    hcst_orca_getImageFormatting(bench);

    bench.orca.subarr_onoff = false;
%     bench.orca.imSizeBytes = hcst_orca_getImageSizeBytes(bench);
%     if verbose
%         disp('orca Camera sub-window changed:');
% %         disp(['     image size (bytes) = ',num2str(bench.orca.imSizeBytes)]);
%         disp(['     AOIHeight = ',num2str(bench.orca.AOIHeight)]);
%         disp(['     AOIWidth  = ',num2str(bench.orca.AOIWidth)]);
% %         disp(['     AOIStride = ',num2str(bench.orca.AOIStride)]);
%     end
end

