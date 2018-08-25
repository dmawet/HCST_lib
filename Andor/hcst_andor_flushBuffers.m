function hcst_andor_flushBuffers(bench)
%hcst_andor_flushBuffers(bench)
%
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.


    % Equivalent to AT_Flush(Handle);
    err = calllib('lib', 'AT_Flush', bench.andor.andor_handle);
    if(err~=0)
        disp('Failed to flush buffer!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Flush']);
    end

end

