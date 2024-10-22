function hcst_orca_resetSubwindow(bench, tint)
%hcst_orca_resetSubwindow(bench)
% Resets the subwindow of the Orca Quest camera.
%
%   - Updates the 'bench' struct 
%   - Uses the dcam.py class
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.



% 
%     new_tint = bench.orca.pyObj.prop_setgetvalue(DCAM_IDPROP.EXPOSURETIME, tint);
% 
%     if(new_tint==false)
%         error(['HCST_lib ORCA ERROR:',bench.orca.pyObj.lasterr()]);
%     end
% 
%     
%     disp(['Orca Quest tint set to ',num2str(new_tint),' sec']);

    
end