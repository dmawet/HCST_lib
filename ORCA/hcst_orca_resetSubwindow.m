function hcst_orca_resetSubwindow(bench)
%hcst_orca_resetSubwindow(bench)
% Resets the subwindow of the Orca Quest camera.
%
%   - Updates the 'bench' struct 
%   - Uses the dcam.py class
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.


    verbose = true;

%     if(nargin>4)
%         verbose = varargin{1};
%     end

%     orca_handle = bench.orca.orca_handle;
    DCAM_IDPROP = bench.orca.dcamapi4.DCAM_IDPROP;
    
    subarr_onoff = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.SUBARRAYMODE, bench.orca.dcamapi4.DCAMPROP.MODE.OFF);
    if subarr_onoff == false
        disp(bench.orca.pyObj.lasterr())
        error(['HCST_lib ORCA ERROR:']);
    else
        disp(['Subarray off ', num2str(subarr_onoff)])
    end 

    
    hcst_orca_getImageFormatting(bench);

    bench.orca.subarr_onoff = false;

    bench.orca.AOIWidth = bench.orca.AOIWidth0;
    bench.orca.AOIHeight = bench.orca.AOIHeight0;
    bench.orca.AOILeft = 1;
    bench.orca.AOITop = 1;
	bench.orca.centcol = bench.orca.centcol0;
	bench.orca.centrow = bench.orca.centrow0;

    
end