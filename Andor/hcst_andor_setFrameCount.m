function hcst_andor_setFrameCount(bench,count)
%hcst_andor_setFrameCount(bench,count) Changes the frame count for fixed
%mode
%
%   - Sets the FrameCount to count
%   - Updates the 'bench' struct using
%       the hcst_andor_getExposureTime function.
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'count' - Number of frames to acquire

    andor_handle = bench.andor.andor_handle;
    
    % Set FrameCount to the number of frames

    featurePtr = libpointer('voidPtr',int32(['FrameCount',0]));

    err = calllib('lib', 'AT_SetInt', andor_handle, featurePtr, int64(count));
    if(err~=0)
        disp('Failed to set FrameCount!')
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end

    
end

