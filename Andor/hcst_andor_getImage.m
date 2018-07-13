function im = hcst_andor_getImage(bench)
%hcst_andor_getImage Returns image from the the Andor Neo camera
%
%   - Returns an image from the Andor Neo camera 
%   - Assumed hcst_config() and setUpAndor has already been run.
%   - 
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:   
%       'bench' - object - contains all pertinent bench information and
%           instances. It is created by the hcst_config() function.
%
%   Outputs
%       'im' - double array - The image

    andor_handle = bench.andor.andor_handle;
    BufferSize = bench.andor.imSizeBytes;
    AOIHeight = bench.andor.AOIHeight;
    AOIWidth  = bench.andor.AOIWidth;
    AOIStride = bench.andor.AOIStride;
    numCoadds = bench.andor.numCoadds;

    if(hcst_andor_getPixelEncodingIndex(bench)~=2)
        error('HCST_lib Andor lib ERROR: hcst_andor_getImage requires 16-bit mode.');
    end
    
    % Equivalent to AT_QueueBuffer(Handle, UserBuffer, BufferSize)
    UserBufferPtr = libpointer('uint8Ptr',uint8(zeros(BufferSize,1)));

    err = calllib('lib', 'AT_QueueBuffer', andor_handle, UserBufferPtr, int32(BufferSize));
    if(err~=0)
        disp('Failed to queue the buffer!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_QueueBuffer']);
    end
    % UserBuffer = get(UserBufferPtr);
    % imvec1 = UserBuffer.Value;

    % -------------------------------------------------------------------%
    
    % Set FrameCount to the number of frames

    FrameCountFeaturePtr = libpointer('voidPtr',int32(['FrameCount',0]));

    err = calllib('lib', 'AT_SetInt', andor_handle, FrameCountFeaturePtr, int64(numCoadds));
    if(err~=0)
        disp('Failed to set FrameCount!')
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_SetInt']);
    end

    
    % -------------------------------------------------------------------%
    
    % Equivalent to AT_Command(Handle, L"AcquisitionStart");
    acqStartStrPtr = libpointer('voidPtr',int32(['AcquisitionStart',0]));

    err = calllib('lib', 'AT_Command', andor_handle, acqStartStrPtr);
    if(err~=0)
        disp('Failed to start acquisition!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Command']);
    end
    
    % -------------------------------------------------------------------%
    im = zeros(bench.andor.AOIHeight,bench.andor.AOIWidth);
    for coadd = 1:numCoadds
    
        % Equivalent to AT_WaitBuffer(Handle, &Buffer, &BufferSize, AT_INFINITE);
        bufferPtr = libpointer('uint8PtrPtr',uint8(zeros(BufferSize,1)));
        bufferSizePtr = libpointer('int32Ptr',int32(BufferSize));

        err = calllib('lib', 'AT_WaitBuffer', andor_handle, bufferPtr, bufferSizePtr, uint32(1e6) );
        if(err~=0)
            disp('Failed to run WaitBuffer!');
            error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_WaitBuffer']);
        end

        buffer = get(bufferPtr);
        imvec = buffer.Value;
        imvec16 = typecast(imvec,'uint16');

        tmp = reshape(imvec16,[AOIStride/2,AOIHeight])';
        tmp = tmp(:,1:(end-AOIStride/2+AOIWidth));

        im = im + double(tmp);
        
        err = calllib('lib', 'AT_QueueBuffer', andor_handle, UserBufferPtr, int32(BufferSize));
        if(err~=0)
            disp('Failed to queue the buffer!');
            error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_QueueBuffer']);
        end
        
    end

    % -------------------------------------------------------------------%

    % Equivalent to AT_Command(Handle, L"AcquisitionStop");
    acqStopStrPtr = libpointer('voidPtr',int32(['AcquisitionStop',0]));

    err = calllib('lib', 'AT_Command', andor_handle, acqStopStrPtr);
    if(err~=0)
        disp('Failed to stop acquisition!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Command']);
    end

    % -------------------------------------------------------------------%
    
    % Equivalent to AT_Flush(Handle);
    err = calllib('lib', 'AT_Flush', andor_handle);
    if(err~=0)
        disp('Failed to flush buffer!');
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Flush']);
    end

    % -------------------------------------------------------------------%
    
end

