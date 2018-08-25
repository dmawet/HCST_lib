function hcst_andor_createBufferPtrs(bench)
%hcst_andor_createBufferPtrs(bench) 
%
%   - Uses the atcore.h and libatcore.so 'c' libraries
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.


    bench.andor.imSizeBytes = hcst_andor_getImageSizeBytes(bench);
    BufferSize = bench.andor.imSizeBytes;
    
    % Equivalent to AT_QueueBuffer(Handle, UserBuffer, BufferSize)
    userBufferPtr = libpointer('uint8Ptr',uint8(zeros(BufferSize,1)));

    bench.andor.userBufferPtr = userBufferPtr;
    
	%For AT_WaitBuffer(Handle, &Buffer, &BufferSize, AT_INFINITE);
    bench.andor.bufferPtr = libpointer('uint8PtrPtr',uint8(zeros(BufferSize,1)));
    bench.andor.bufferSizePtr = libpointer('int32Ptr',int32(BufferSize));
    
    disp('Andor Neo buffer pointers created.');
end

