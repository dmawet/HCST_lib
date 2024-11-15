function hcst_orca_setTriggerMode(bench, trigger_mode)

    if strcmp(trigger_mode, 'batch')
        disp('Changing the trigger mode to software')
        triggersource = 3;
        triggermode = 6;


    elseif strcmp(trigger_mode, 'mechanical')
        disp('Changing the trigger mode to mechanical')
        error('FEATURE NOT IMPLEMENTED, PLEASE PICK batch OR single')

    else
        disp('Changing the trigger mode to internal')
        triggersource = 1;
        triggermode = 1;
    
    end
    
    % DCAMPROP.TRIGGERSOURCE.INTERNAL = 1 , use for single frames
    % DCAMPROP.TRIGGERSOURCE.SOFTWARE = 3 , use for batch frames

    bench.orca.triggersource = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.TRIGGERSOURCE, triggersource);%DCAMPROP.TRIGGERSOURCE.SOFTWARE);
    if bench.orca.triggersource == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end
    
    % Set trigger mode 
    % NORMAL = 1
    % PIV = 3
    % START = 6
    bench.orca.triggermode = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.TRIGGER_MODE, triggermode);
    if bench.orca.triggermode == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end




end