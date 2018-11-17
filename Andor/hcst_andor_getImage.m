function im = hcst_andor_getImage(bench)
%hcst_andor_getImage Returns image from the the Andor Neo camera
%
%   - Returns a single image from the Andor Neo camera 
%   - Assumed hcst_config() and setUpAndor has already been run.
%   
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:   
%       'bench' - object - contains all pertinent bench information and
%           instances. It is created by the hcst_config() function.
%
%   Outputs
%       'im' - double array - The image


    BufferSize = bench.andor.imSizeBytes;
    AOIHeight = bench.andor.AOIHeight;
    AOIWidth  = bench.andor.AOIWidth;
    AOIStride = bench.andor.AOIStride;
    numCoadds = bench.andor.numCoadds;
    
    % Check if the buffer pointers exist. If they don't, make them.
    if(or(~isfield(bench.andor,'userBufferPtr'),~isfield(bench.andor,'bufferPtr')))
        hcst_andor_createBufferPtrs(bench)
    end
    
    % For AT_QueueBuffer(Handle, UserBuffer, BufferSize)
    userBufferPtr = bench.andor.userBufferPtr;

    % For AT_WaitBuffer(Handle, &Buffer, &BufferSize, AT_INFINITE);
    bufferPtr = bench.andor.bufferPtr;
    bufferSizePtr = bench.andor.bufferSizePtr;
        
    % -------------------------------------------------------------------%
    
    % If not in continuous mode, start acquisition 
    % If in continuous mode and not acquiring, start the acq.
    % If continuous mode and acquiring, move on
    if(~logical(bench.andor.continuous))
        hcst_andor_setFrameCount(bench,numCoadds)
        hcst_andor_toggleAcq(bench,true);
    elseif(~logical(bench.andor.acquiring))
        disp('Andor Neo is in continuous mode. Starting acquisition.');
        hcst_andor_toggleAcq(bench,true);
    end
    
    % -------------------------------------------------------------------%
    
    im = zeros(bench.andor.AOIHeight,bench.andor.AOIWidth);
    
    for coadd = 1:numCoadds
        try
            % Queue the buffer
            err = calllib('lib', 'AT_QueueBuffer', bench.andor.andor_handle, userBufferPtr, int32(BufferSize));
            if(err~=0)
                disp('Failed to queue the buffer!');
                error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_QueueBuffer']);
            end
        catch
            hcst_andor_createBufferPtrs(bench)
            % Create a new buffer and try again
            err = calllib('lib', 'AT_QueueBuffer', bench.andor.andor_handle, userBufferPtr, int32(BufferSize));
            if(err~=0)
                disp('Failed to queue the buffer!');
                error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_QueueBuffer']);
            end
            
        end

        err = calllib('lib', 'AT_WaitBuffer', bench.andor.andor_handle, bufferPtr, bufferSizePtr, uint32(1e6) );
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
        
    end
    
    if(bench.andor.warnKernLimit)
        kernLimit = 5e6;%counts/sec/pix
        maxCPS = max(im(:)/numCoadds/bench.andor.tint);
        if(maxCPS > kernLimit)
            warning(['Max cps ',num2str(maxCPS/kernLimit,3),'x the Kern limit']);
        end
    end

    % -------------------------------------------------------------------%
    
	if(~logical(bench.andor.continuous))
        hcst_andor_toggleAcq(bench,false);
        hcst_andor_flushBuffers(bench)
    end
    
end

