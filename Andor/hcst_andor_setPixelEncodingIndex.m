function hcst_andor_setPixelEncodingIndex(B,pixEncodingIndex)
%hcst_andor_setPixelEncodingIndex(B,pixEncodingIndex)
%Changes the pixel encoding index of the Andor Neo camera
%
%   - Sets the pixel encoding index to pixEncodingIndex
%   - Updates the B.bench.andor.pixelEncodingIndex variable using
%           hcst_andor_getPixelEncodingIndex function.
%   - Updates the B.bench.andor.imSizeBytes variable using
%           hcst_andor_getImageSizeBytes function.
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%       'pixEncodingIndex' - The pixel encoding index 
%           Options (see Andor SDK Docs for detailed info):
%               0: 'Mono12'
%               1: 'Mono12Packed'
%               2: 'Mono16'
%               3: 'Mono32'

    andor_handle = B.bench.andor.andor_handle;

    pixelEncodingFeaturePtr = libpointer('voidPtr',int32(['PixelEncoding',0]));
    
    % Set bitdepth with AT_SetEnumIndex(AT_H Hndl, AT_WC* Feature, int Index)
    err = calllib('lib', 'AT_SetEnumIndex', andor_handle, pixelEncodingFeaturePtr, ...
                                      int32(pixEncodingIndex));
    if(err~=0)
        disp('Failed to change pixelEncodingIndex!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetEnumIndex']);
    end 
    
    % Update the bench struct
	B.bench.andor.pixelEncodingIndex = int32(pixEncodingIndex);
    
    % Query the new pixel encoding index
    new_pei = hcst_andor_getPixelEncodingIndex(B);
    
	B.bench.andor.pixelEncodingIndex = new_pei;
    B.bench.andor.imSizeBytes = hcst_andor_getImageSizeBytes(B);
end

