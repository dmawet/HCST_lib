function img = hcst_orca_getSingleFrame(bench)
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

  if bench.orca.triggersource ~=1
    hcst_orca_setTriggerMode(bench, 'single')
  end
  % Get exposure time in seconds
  timeout_count = 0;
  tint = bench.orca.pyObj.prop_getvalue(bench.orca.dcamapi4.DCAM_IDPROP.EXPOSURETIME);
  if bench.orca.pyObj.buf_alloc(int32(1))
        if bench.orca.pyObj.cap_snapshot()
            timeout_milisec = int32(1000*tint+500);
            while true
                if bench.orca.pyObj.wait_capevent_frameready(timeout_milisec)
                    img = double(bench.orca.pyObj.buf_getlastframedata());
                    break
                end

                dcamerr = bench.orca.pyObj.lasterr();
                if dcamerr == bench.orca.dcamapi4.DCAMERR.TIMEOUT
                    timeout_count = timeout_count + 1;
                    disp('===: timeout')
                    if timeout_count > 5 
                        disp('Exceeded allowable timeout count.')
                        break
                    else
                        continue
                    end
                end
                disp(['-NG: Dcam.wait_event() fails with error '])
                disp(dcamerr)
                break
            end
        else
            disp(['-NG: Dcam.cap_start() fails with error'])
            disp(bench.orca.pyObj.lasterr())
        end

        buff_release = bench.orca.pyObj.buf_release();
        if ~buff_release
            disp('-NG: Camera failed to release buffer.')
        end
  else
    disp('-NG: Dcam.buf_alloc(1) fails with error: ')
    disp(bench.orca.pyObj.lasterr())

        

  end

end