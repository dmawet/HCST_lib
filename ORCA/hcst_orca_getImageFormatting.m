function hcst_orca_getImageFormatting(bench)
%hcst_orca_getImageFormatting Queries the the Orca Quest camera to return the AOIHeight, AOIWidth of the image returned from the buffer
%
%   - Updates the AOIHeight, AOIWidth fields in
%       bench.orca with the values of the image returned by the buffer.
%   - Uses the dcam.py and dcamapi4 'python' libraries
%   
%
%   Input/Output:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%   Function updates the following fields in bench.orca
%       'AOIHeight' - 
%       'AOIWidth'  - 

    DCAM_IDPROP = bench.orca.dcamapi4.DCAM_IDPROP;

    % Get horizontal size of AOI
    aoi_h = bench.orca.pyObj.prop_getvalue(DCAM_IDPROP.SUBARRAYHSIZE);
    if aoi_h == false
        disp('Failed to get image formatting.');
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end
    bench.orca.AOIWidth = aoi_h;

    % Get vertical size of AOI
    aoi_v = bench.orca.pyObj.prop_getvalue(DCAM_IDPROP.SUBARRAYVSIZE);
    if aoi_v == false
        disp('Failed to get image formatting.');
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    end
    bench.orca.AOIHeight = aoi_v;

    % bench.orca.AOIStride = ?

end

