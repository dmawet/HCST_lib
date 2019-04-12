function tb_NKT_setWvlRange(bench,lower_nm,upper_nm)
%tb_NKT_setWvlRange(bench,lower,upper) Set wavelength of the NKT Varia.
%
%   Inputs:
%       'bench' - object containing all pertinent bench information
%           and instances. It is created by the tb_config() function.
%       'lower_nm' - lower wavelength (nm)
%       'upper_nm' - upper wavelength (nm)
%
%   author: G. Ruane
%   last modified: March 26, 2019

    NKT_MIN_WVL = 400;% nm
    NKT_MAX_WVL = 900;% nm

    % Get the current lower and upper wavelengths  
    [currentlower,currentupper] = tb_NKT_getWvlRange(bench);
    
	% Check that the wavelengths make sense, if not, keep them the same
    if(or(lower_nm < NKT_MIN_WVL,lower_nm > NKT_MAX_WVL))
        lower_nm = currentlower;
        error('     Varia: lower wavelength outside of the allowable range.');
    end
    if(or(upper_nm < NKT_MIN_WVL,upper_nm > NKT_MAX_WVL))
        upper_nm = currentupper;
        error('     Varia: upper wavelength outside of the allowable range.');
    end

    % If the passed wavelengths are different than the current wavelengths,
    % update them
    didsomething = false;
    if(currentlower ~= lower_nm)
        bench.NKT.nktobj.set_varia_lwpsetpoint(lower_nm);
        didsomething = true;
    end
	if(currentupper ~= upper_nm)
        bench.NKT.nktobj.set_varia_swpsetpoint(upper_nm);
        didsomething = true;
    end

    if(didsomething)
        pause(bench.NKT.delay);
    
        [currentlower,currentupper] = tb_NKT_getWvlRange(bench);
        
        disp(['     Varia: wavelength range set to ',...
            num2str(currentlower),'-',num2str(currentupper),'nm.']);
    end
    
    
    
    % % Save backup bench object
    % hcst_backUpBench(bench)

end
