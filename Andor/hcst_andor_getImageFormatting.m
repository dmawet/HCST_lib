function hcst_andor_getImageFormatting(B)
%hcst_andor_getImageFormatting(B)
%Queries the the Andor Neo camera to return the AOIHeight, AOIWidth, and
%AOIStride of the image returned from the buffer
%
%   - Updates the AOIHeight, AOIWidth, and AOIStride fields in
%       B.bench.andor with the values of the image returned by the buffer.
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Input/Output:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%   Function updates the following fields in B.bench.andor
%       'AOIHeight' - The number of bytes in height
%       'AOIWidth'  - The number of bytes wide
%       'AOIStride' - Width including zero padding


    andor_handle = B.bench.andor.andor_handle;

    % //Retrieve the dimensions of the image
    % AT_GetInt(Hndl, L"AOIStride", &Stride);
    % AT_GetInt(Hndl, L"AOIWidth", &Width);
    % AT_GetInt(Hndl, L"AOIHeight", &Height);

    % Equivalent to AT_GetInt(Hndl, L"AOIHeight", &Height);
    heightPtr1 = libpointer('voidPtr',int32(['AOIHeight',0]));
    heightPtr2 = libpointer('int64Ptr',int64(0));
    err = calllib('lib', 'AT_GetInt', andor_handle, heightPtr1, heightPtr2);
    if(err~=0)
        disp('Failed to get image formatting.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetInt']);
    end
    tmp = get(heightPtr2);
    B.bench.andor.AOIHeight = tmp.Value;

    % Equivalent to AT_GetInt(Hndl, L"AOIWidth", &Width);
    widthPtr1 = libpointer('voidPtr',int32(['AOIWidth',0]));
    widthPtr2 = libpointer('int64Ptr',int64(0));
    err = calllib('lib', 'AT_GetInt', andor_handle, widthPtr1, widthPtr2);

    if(err~=0)
        disp('Failed to get image formatting.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetInt']);
    end
    tmp = get(widthPtr2);
    B.bench.andor.AOIWidth = tmp.Value;

    % Equivalent to AT_GetInt(Hndl, L"AOIStride", &Stride);
    stridePtr1 = libpointer('voidPtr',int32(['AOIStride',0]));
    stridePtr2 = libpointer('int64Ptr',int64(0));
    err = calllib('lib', 'AT_GetInt', andor_handle, stridePtr1, stridePtr2);
    if(err~=0)
        disp('Failed to get image formatting.');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetInt']);
    end
    tmp = get(stridePtr2);
    B.bench.andor.AOIStride = tmp.Value;

end

