function hcst_andor_setSubwindow(B,centerrow,centercol,framesize)
%hcst_andor_setSubwindow(B,centerrow,centercol,framesize)
%Changes the subwindow of the Andor Neo camera. Assumes the subwindow is a
%square with an even number of pixels. 
%
%   - Crops the Andor Neo image to a frame size of 'framesize' centered at
%       (centerrow,centercol)
%   - Updates the 'B.bench' struct 
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%       'centerrow', 'centercol' - The pixel index in the full frame mode
%           of the pixel where the subwindow will be centered 
%       'frame', 'centercol' - The pixel index in the full frame mode of
%           the pixel where the subwindow will be centered 


    andor_handle = B.bench.andor.andor_handle;
    
%     bench.andor.AOIWidth0 = 2560;
%     bench.andor.AOIHeight0 = 2160;
    
    B.bench.andor.AOIWidth = framesize;
    B.bench.andor.AOIHeight = framesize;
    B.bench.andor.AOILeft = centercol - framesize/2 - 1;
    B.bench.andor.AOITop = centerrow - framesize/2 - 1;
	B.bench.andor.centcol = centercol;
	B.bench.andor.centrow = centerrow;
    
    if(B.bench.andor.AOIHeight~=B.bench.andor.AOIWidth)
        error('HCST currently only supports square, even sub-windows.')
    elseif(mod(B.bench.andor.AOIHeight,2)~=0)
        error('HCST currently only supports even sized sub-windows.');
    end
               
    
    % Equivalent to AT_SetFloat(Handle, L”ExposureTime”, 0.01);
    FeaturePtr = libpointer('voidPtr',[int32('AOIWidth'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, FeaturePtr, int64(B.bench.andor.AOIWidth));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end
    
    % Equivalent to AT_SetFloat(Handle, L”ExposureTime”, 0.01);
    FeaturePtr = libpointer('voidPtr',[int32('AOILeft'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, FeaturePtr, int64(B.bench.andor.AOILeft));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end
    
    % Equivalent to AT_SetFloat(Handle, L”ExposureTime”, 0.01);
    FeaturePtr = libpointer('voidPtr',[int32('AOIHeight'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, FeaturePtr, int64(B.bench.andor.AOIHeight));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end
    
    % Equivalent to AT_SetFloat(Handle, L”ExposureTime”, 0.01);
    FeaturePtr = libpointer('voidPtr',[int32('AOITop'),0]);
    err = calllib('lib', 'AT_SetInt', andor_handle, FeaturePtr, int64(B.bench.andor.AOITop));
    if(err~=0)
        disp('Failed to change the AOI size.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end
    
	hcst_andor_getImageFormatting(B);
    B.bench.andor.imSizeBytes = hcst_andor_getImageSizeBytes(B);
    
    disp('Andor Neo Camera sub-window changed:');
    disp(['     image size (bytes) = ',num2str(B.bench.andor.imSizeBytes)]);
    disp(['     AOIHeight = ',num2str(B.bench.andor.AOIHeight)]);
    disp(['     AOIWidth  = ',num2str(B.bench.andor.AOIWidth)]);
    disp(['     AOIStride = ',num2str(B.bench.andor.AOIStride)]);
end

