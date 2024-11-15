function tint = hcst_orca_getExposureTime(bench)
%hcst_orca_getExposureTime Queries the exposure time setting of the orca Neo camera
%
%   - Returns the current exposure time
%   - Uses the dcam.py class
%   
%
%   Inputs:
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%   Outputs
%       'tint' - The exposure time in seconds 


    tint = bench.orca.pyObj.prop_getvalue(bench.orca.dcamapi4.DCAM_IDPROP.EXPOSURETIME);

    if(tint==false)
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end
    
end