function hcst_andor_setSubwindow(bench, centerrow, centercol, framesize)
%hcst_andor_setSubwindow Changes the subwindow of the Andor Neo camera. Assumes the subwindow is a square with an even number of pixels. 
%
%   - Crops the Andor Neo image to a frame size of 'framesize' centered at
%       (centerrow,centercol)
%   - Updates the 'bench' struct 
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'centerrow', 'centercol' - The pixel index in the full frame mode
%           of the pixel where the subwindow will be centered (starting
%           index is 1)
%       'framesize' - The size of the sub-window in pixels 


    andor_handle = bench.andor.andor_handle;
    
    
    bench.andor.AOIWidth = framesize;
    bench.andor.AOIHeight = framesize;
    bench.andor.AOILeft = centercol - framesize/2 - 1;
    bench.andor.AOITop = centerrow - framesize/2 - 1;
	bench.andor.centcol = centercol;
	bench.andor.centrow = centerrow;
    
    if(bench.andor.AOIHeight~=bench.andor.AOIWidth)
        error('HCST currently only supports square, even sub-windows.')
    elseif(mod(bench.andor.AOIHeight,2)~=0)
        error('HCST currently only supports even sized sub-windows.');
    end
    
    
    featurePtr = libpointer('voidPtr',[int32('AOIWidth'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, featurePtr, int64(bench.andor.AOIWidth));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end
    
    
    featurePtr = libpointer('voidPtr',[int32('AOILeft'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, featurePtr, int64(bench.andor.AOILeft));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end

    
    featurePtr = libpointer('voidPtr',[int32('AOIHeight'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, featurePtr, int64(bench.andor.AOIHeight));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end
    
    
    featurePtr = libpointer('voidPtr',[int32('AOITop'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, featurePtr, int64(bench.andor.AOITop));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end
    
    
    hcst_andor_getImageFormatting(bench);
    bench.andor.imSizeBytes = hcst_andor_getImageSizeBytes(bench);
    hcst_andor_createBufferPtrs(bench)
    
    disp('Andor Neo Camera sub-window changed:');
    disp(['     image size (bytes) = ',num2str(bench.andor.imSizeBytes)]);
    disp(['     AOIHeight = ',num2str(bench.andor.AOIHeight)]);
    disp(['     AOIWidth  = ',num2str(bench.andor.AOIWidth)]);
    disp(['     AOIStride = ',num2str(bench.andor.AOIStride)]);
end

