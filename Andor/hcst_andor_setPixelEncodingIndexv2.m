function hcst_andor_setPixelEncodingIndex(bench,pei)
%hcst_andor_setPixelEncodingIndex Changes the pixel encoding index of the Andor Neo camera
%
%   - Sets the pixel encoding index to pixEncodingIndex
%   - Updates the bench.andor.pixelEncodingIndex variable using
%           hcst_andor_getPixelEncodingIndex function.
%   - Updates the bench.andor.imSizeBytes variable using
%           hcst_andor_getImageSizeBytes function.
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'pei' - The pixel encoding index 
%           Options (see Andor SDK Docs for detailed info):
%               0: 'Mono12'
%               1: 'Mono12Packed'
%               2: 'Mono16'
%               3: 'Mono32'

    andor_handle = bench.andor.andor_handle;

    pixelEncodingFeaturePtr = libpointer('voidPtr',int32(['PixelEncoding',0]));
    
    % Set bitdepth with AT_SetEnumIndex(AT_H Hndl, AT_WC* Feature, int Index)
%     err = calllib('lib', 'AT_SetEnumIndex', andor_handle, pixelEncodingFeaturePtr, ...
%                                       int32(pei));
%     aux = libpointer('voidPtr',int32(['Mono16',0]));
%     queryPtr = libpointer('doublePtr',0);
%     query = get(queryPtr);
%     aux = query.Value;
    aux = libpointer('int32Ptr',int32(0));

    err = calllib('lib', 'AT_SetEnumIndex', andor_handle, pixelEncodingFeaturePtr, ...
                                      aux);
    if(err~=0)
        disp('Failed to change pixelEncodingIndex!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetEnumIndex']);
    end 
    
    % Update the bench struct
	bench.andor.pixelEncodingIndex = int32(pei);
    
    % Query the new pixel encoding index
    new_pei = hcst_andor_getPixelEncodingIndex(bench);
    
	bench.andor.pixelEncodingIndex = new_pei;
    bench.andor.imSizeBytes = hcst_andor_getImageSizeBytes(bench);
end

