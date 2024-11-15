function hcst_orca_setExposureTime(bench, tint)
%hcst_orca_getExposureTime Queries and sets the exposure time setting of the orca Neo camera
%
%   - Prints the current exposure time
%   - Uses the dcam.py class
%   
%
%   Inputs:
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%



    new_tint = bench.orca.pyObj.prop_setgetvalue(bench.orca.dcamapi4.DCAM_IDPROP.EXPOSURETIME, tint);

    if(new_tint==false)
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end

    
    disp(['Orca Quest tint set to ',num2str(new_tint),' sec']);

    
end