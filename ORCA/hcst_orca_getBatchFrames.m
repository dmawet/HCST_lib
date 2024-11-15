function img = hcst_orca_getBatchFrames(bench)
%hcst_orca_getSingleFrame Function to get single image, mainly for
%debugging
%   
%   - It uses dcam.py
%
%   Arguments/Outputs:
%   hcst_orca_getSingleFrame(bench) Grabs single frame
%       'bench' is the object containing all pertinent bench information and
%           instances. It is created by the hcst_config() function.
%
%

%     bench.orca.pyObj = py.dcam.Dcam(int32(bench.orca.iDevice));
%     cam_isOpen = bench.orca.pyObj.dev_open();


% TODO: adjust error handling

  % Get exposure time in seconds
tint = bench.orca.pyObj.prop_getvalue(bench.orca.dcamapi4.DCAM_IDPROP.EXPOSURETIME);
timeout_millisec = uint16(ceil(tint * 1000 + 1000));

img_coadd = zeros(bench.orca.AOIHeight, bench.orca.AOIWidth);
frames_added = 0;

% Allocate buffer:  
if ~bench.orca.pyObj.buf_alloc(int32(min([bench.orca.numCoadds, 10])))
  return
end

if ~bench.orca.pyObj.cap_start(true)
    % dcam.buf_alloc() should have succeeded
    bench.orca.pyObj.buf_release()
    return
end



timeout_happened = 0;
for i=1:1:bench.orca.numCoadds
    res = false;
    while ~res
        res = bench.orca.pyObj.wait_capevent_frameready(timeout_millisec);
        % frame not ready
%               res = dcamcon.wait_capevent_frameready(timeout_millisec)
        % frame does not come
        dcamerr = bench.orca.pyObj.lasterr();

        if dcamerr ~= bench.orca.dcamapi4.DCAMERR.SUCCESS
            if (dcamerr ~= bench.orca.dcamapi4.DCAMERR.TIMEOUT)
                disp(['-NG: Dcam.wait_event() failed with error '])
                disp(bench.orca.pyObj.lasterr())

                bench.orca.pyObj.cap_stop()
                bench.orca.pyObj.buf_release()

                error(['HCST_lib ORCA ERROR:']);
                
            end
    
            % TIMEOUT error happens
            timeout_happened = timeout_happened + 1;
            if timeout_happened == 1
                disp('Waiting for a frame to arrive.')
                if bench.orca.triggersource == bench.orca.dcamapi4.DCAMPROP.TRIGGERSOURCE.EXTERNAL
                    disp(' Check your trigger source.')
                else
                    disp(' Check your <timeout_millisec> calculation in the code.')
                end
                disp(' Press Ctrl+C to abort.')
            else
                print('.')
                if timeout_happened > bench.orca.max_dropped_frames % calibrate this numner
                   % raise error
                   bench.orca.pyObj.cap_stop()

                   bench.orca.pyObj.buf_release()

                   error(['Exceeded allowed number of timeouts.']);
                end
            end
        end
        
        
    end

    % Successfully grabed frame:
    lastdata = double(bench.orca.pyObj.buf_getlastframedata());

    if lastdata ~= false
        img_coadd = img_coadd + lastdata;
        frames_added = frames_added + 1;
    end


end


 % outside of for loop
bench.orca.pyObj.cap_stop()

bench.orca.pyObj.buf_release()



img = img_coadd/frames_added;

if frames_added ~= bench.orca.numCoadds
    disp(['WARNING: only averaged ', str(frames_added), ' frames, ', str(bench.orca.numCoadds), ' requested.'])
end
   



end