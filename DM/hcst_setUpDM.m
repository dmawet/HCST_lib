function hcst_setUpDM(bench)
%hcst_setUpDM(bench)
%Set up the HCST BMC kilo-DM
%   - This function should be called before calling any other DM functions
%   - It uses the BMC libraries in /opt/Boston Micromachines/lib/Matlab/
%   
%
%   Arguments/Outputs:
%   hcst_setUpDM(bench) 
%       Initializes the BMC DM
%       Updates the andor sub-struct which contains pertinent information 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpDM(bench)
%           Updates 'bench', the DM sub-struct
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

    disp('*** Setting up BMC kilo-DM. ***');

    addpath('/opt/Boston Micromachines/lib/Matlab');

    % ATTENTION: change this string to match the serial number of your hardware
	serialNumber = '25CW005#040';
    bench.DM.serialNumber = serialNumber;
    
    %Get DM struct needed for some functions and some useful settings.
    [err_code, bench.DM.dm] = BMCGetDM();
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    
    % Set DM profile
    profileDir = fullfile('/opt','Boston Micromachines','Profiles');
    err_code = BMCSetProfilesPath(bench.DM.dm, profileDir);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    
    % Set DM map
    mapsDir = fullfile('/opt','Boston Micromachines','Map');
    err_code = BMCSetMapsPath(bench.DM.dm, mapsDir);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    
    % Load the library, open the connection to the driver, and get DM
    % struct needed for some functions and some useful settings.
    % Open the driver and retrieve DM info struct
    try
        [err_code, bench.DM.dm] = BMCOpenDM(serialNumber, bench.DM.dm);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    catch
        disp('Closing current connection...');
        hcst_cleanUpDM(bench);
        disp('Opening a new one...');
        [err_code, bench.DM.dm] = BMCOpenDM(serialNumber, bench.DM.dm);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
        disp('Success!');
    end
    
    
    % Show library functions window
    % libfunctionsview libbmc

    %Retrieve the default driver mapping set in the DM profile.
    % retrieve the default mapping in the variable lut
    [err_code, lut] = BMCGetDefaultMapping(bench.DM.dm);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    bench.DM.lut = lut;

    bench.DM.Nact = 952;
    bench.DM.NactAcross = 34;
    bench.DM.dac_scale = (2^16)-1; % Electronics are 16 bit
    bench.DM.MAX_V = 300;% Max voltage for electronics 
    bench.DM.V2bits = bench.DM.dac_scale/bench.DM.MAX_V;
    bench.DM.cmdLength = bench.DM.dm.size; % Length of command arrays to send
    
    bench.DM.flatvec = hcst_DM_flattenDM_BMCmap(bench, false);

    bench.DM.CONNECTED = true;

%     % Hack to check if DM is connected:
%     if ~bench.andor.CONNECTED
%         hcst_setUpAndor(bench, false)
%     else
%         hcst_DM_zeroDM(bench)
%         ref_im = hcst_andor_getImage(bench);
%         hcst_DM_testPatternET(bench, 10);
%         im = hcst_andor_getImage(bench);
%         if max(max(ref_im - im)) > 1e4
%             bench.DM.CONNECTED = true;
%         else
%             bench.DM.CONNECTED = false;
%             error('Test pattern on DM failed to significantly change image. Either DM driver is not connected or image is off camera.')
%         end
%     end
    
    disp('*** BMC kilo-DM initialized. ***');

    % Save backup bench object
    hcst_backUpBench(bench)
    
end

