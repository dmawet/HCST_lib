function rate = hcst_andor_getFrameRate(bench)
%hcst_andor_getFrameRate Queries the current frame rate setting of the Andor Neo 
%
%   - Returns the current sensor temp
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%   Outputs
%       'rate' - Frame rate in Hz

    andor_handle = bench.andor.andor_handle;

    % Equivalent to AT_GetFloat(Handle, L”FrameRate”, 0.01);
    FeaturePtr = libpointer('voidPtr',[int32('FrameRate'),0]);
    QueryPtr = libpointer('doublePtr',0);
    err = calllib('lib', 'AT_GetFloat', andor_handle, FeaturePtr, QueryPtr);
    if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetFloat']);
    end
    Query = get(QueryPtr);
    rate = Query.Value;
    
    
end

