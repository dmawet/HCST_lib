function hcst_orca_setBinning(bench, binning)
    DCAM_IDPROP = bench.orca.dcamapi4.DCAM_IDPROP;

    % Acceptable binning values:
    binning_options = [1,2,4,8,16];
    
    % Check if binning value is valid
    if size(find(binning==binning_options), 2) == 0
        error('Binning value must be 1, 2, 4, 8, or 16')
    end

    try
        % Set independent binning to false
%         ind = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.BINNING_INDEPENDENT, false);

        % Change binning:
        new_binning = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.BINNING, uint16(binning));

        if new_binning == false %|| ind == false
            disp(bench.orca.pyObj.lasterr())
            error(['HCST_lib ORCA ERROR:']);
        else
            bench.orca.binning = new_binning;
            disp(['Binning changed to ', num2str(new_binning)])
        end 

    catch

        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);

    end


end