function img = hcst_ueye_getImage(tb)
    % Set Exposure time
    t_exp_applied = tb.UEYE.ueobj.set_exposure(tb.UEYE.exposure_time);
    disp(['Exposure time requested was ', str(tb.UEYE.exposure_time)])
    disp(['Exposure time used was ', str(t_exp_applied)])
    tb.UEYE.exposure_time = t_exp_applied;
    timeout = t_exp_applied * 10;
    img = tb.UEYE.ueobj.capture_image(timeout);
    
end