function pei = hcst_andor_getPixelEncodingIndex(B)
%pei = hcst_andor_getPixelEncodingIndex(bench)
%Queries the pixel encoding index of the Andor Neo camera
%
%   - Returns the current pixel encoding index
%   - Also checks that the bench struct contains the correct value
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:   
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%   Outputs
%       'pei' - The pixel encoding index 
%           Options (see Andor SDK Docs for detailed info):
%               0: 'Mono12'
%               1: 'Mono12Packed'
%               2: 'Mono16'
%               3: 'Mono32'


    andor_handle = B.bench.andor.andor_handle;

    pixelEncodingFeaturePtr = libpointer('voidPtr',int32(['PixelEncoding',0]));
    pixelEncodingQueryPtr = libpointer('voidPtr',int32(10));% Initialized to an unrealistic value to ensure the pixel encoding index changed correctly

    err = calllib('lib', 'AT_GetEnumIndex', andor_handle, pixelEncodingFeaturePtr, ...
                                      pixelEncodingQueryPtr);
    tmp = get(pixelEncodingQueryPtr);
    pei = tmp.Value;
    if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetEnumIndex']);
    end

    % Check that the bench struct has the correct value
    if(B.bench.andor.pixelEncodingIndex~=pei)
        disp('HCST_lib WARNING: the pixel encoding index was incorrect in the ''bench'' struct.');
        disp('Setting to the correct value.');
        B.bench.andor.pixelEncodingIndex = pei;
    end
    
    
end

