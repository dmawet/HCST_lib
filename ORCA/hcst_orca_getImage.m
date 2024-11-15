function img = hcst_orca_getImage(bench)
% hcst_orca_getImage Function to get single image, mainly for
% debugging
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

AOIHeight = bench.orca.AOIHeight;
AOIWidth  = bench.orca.AOIWidth;
% AOIStride = bench.orca.AOIStride;
numCoadds = bench.orca.numCoadds;

if(~logical(bench.orca.continuous))

  % Get exposure time in seconds
  tint = bench.orca.pyObj.prop_getvalue(bench.orca.dcamapi4.DCAM_IDPROP.EXPOSURETIME);
  if bench.orca.pyObj.buf_alloc(int32(numCoadds))
        if bench.orca.pyObj.cap_snapshot()
            timeout_milisec = int32(1000 * tint * numCoadds + 500);
            while true
                if bench.orca.pyObj.wait_capevent_frameready(timeout_milisec)
                    img = uint16(bench.orca.pyObj.buf_getlastframedata());
                    break
                end

                dcamerr = bench.orca.pyObj.lasterr();
                if dcamerr == bench.orca.dcamapi4.DCAMERR.TIMEOUT
                    disp('===: timeout')
                    continue
                end
                disp(['-NG: Dcam.wait_event() fails with error '])
                disp(dcamerr)
                break
            end
        else
            disp(['-NG: Dcam.cap_start() fails with error'])
            disp(bench.orca.pyObj.lasterr())
        end

        bench.orca.pyObj.buf_release()
  else
    disp('-NG: Dcam.buf_alloc(1) fails with error: ')
    disp(bench.orca.pyObj.lasterr())

        

  end


else

    disp('Orca Quest is in continuous mode. Starting acquisition.');
    disp('This is not implemented yet!');

end

end