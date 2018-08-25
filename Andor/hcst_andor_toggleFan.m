function hcst_andor_toggleFan(bench,option)
%hcst_andor_toggleFan Turns the fan off/low/on in the Andor Neo camera
%
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%       'option' - The fan speed index
%           Options (see Andor SDK Docs for detailed info):
%               'off': Turns fan off    (index 0)
%               'low': Turns fan on low (index 1)
%               'on': Turns fan on      (index 2)


    andor_handle = bench.andor.andor_handle;

    featurePtr = libpointer('voidPtr',int32(['FanSpeed',0]));
    
    switch option
        case 'off'
            index = 0;
        case 'low'
            index = 1;
        case 'on'
            index = 2;
    end

    % Set bitdepth with AT_SetEnumIndex(AT_H Hndl, AT_WC* Feature, int Index)
    err = calllib('lib', 'AT_SetEnumIndex', andor_handle, featurePtr, ...
                                      int32(index));
    if(err~=0)
        disp('Failed to change pixelEncodingIndex!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetEnumIndex']);
    end 
    
    bench.andor.fan = index;
end

