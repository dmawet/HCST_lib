function hcst_setUpUeye(tb, ue_lib_PATH, camera_id)

%     ue_lib_PATH = tb.info.UEYE_lib_PATH;
    if count(py.sys.path, ue_lib_PATH) == 0
        insert(py.sys.path, int32(0), ue_lib_PATH)
    end
    
    disp('*** Connecting to Ueye Camera ***')
    
%     camera_id = tb.UEYE.camera_id;
    
    tb.UEYE.ueobj = py.camera.Camera(camera_id, 3000);
    
    tb.UEYE.connected = true;
    
    disp('*** Ueye Camera Connected ***')



end