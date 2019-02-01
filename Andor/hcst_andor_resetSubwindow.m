function hcst_andor_resetSubwindow(bench)
%hcst_andor_resetSubwindow(bench)
% Resets the subwindow of the Andor Neo camera.
%
%   - Updates the 'bench' struct 
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.


    andor_handle = bench.andor.andor_handle;
    
    
    bench.andor.AOIWidth = bench.andor.AOIWidth0;
    bench.andor.AOIHeight = bench.andor.AOIHeight0;
    bench.andor.AOILeft = 1;
    bench.andor.AOITop = 1;
	bench.andor.centcol = bench.andor.centcol0;
	bench.andor.centrow = bench.andor.centrow0;
    
    
    
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
    %disp(['     AOIStride = ',num2str(bench.andor.AOIStride)]);
end

