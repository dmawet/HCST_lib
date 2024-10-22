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


    tint = bench.orca.pyObj.prop_getvalue(DCAM_IDPROP.EXPOSURETIME);

    if(tint==false)
        error(['HCST_lib ORCA ERROR:',bench.orca.pyObj.lasterr()]);
    end
    
end