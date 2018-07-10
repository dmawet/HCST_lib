function hcst_setUpDM(B)
%bench = hcst_setUpDM(bench)
%Set up the HCST BMC kilo-DM
%   - This function should be called before calling any other DM functions
%   - It uses the BMC libraries in /opt/Boston Micromachines/lib/Matlab/
%   
%
%   Arguments/Outputs:
%   bench = hcst_setUpDM(bench) 
%       Initializes the BMC DM
%       Updates the andor sub-struct which contains pertient information 
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpDM(bench)
%           Updates 'bench', the DM sub-struct
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

    addpath('/opt/Boston Micromachines/lib/Matlab');

    % ATTENTION: change this string to match the serial number of your hardware
	serialNumber = '25CW005#040';
    B.bench.DM.serialNumber = serialNumber;
    
    %Get DM struct needed for some functions and some useful settings.
    [err_code, B.bench.DM.dm] = BMCGetDM();
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    
    % Set DM profile
    profileDir = fullfile('/opt','Boston Micromachines','Profiles');
    err_code = BMCSetProfilesPath(B.bench.DM.dm, profileDir);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    
    % Set DM map
    mapsDir = fullfile('/opt','Boston Micromachines','Map');
    err_code = BMCSetMapsPath(B.bench.DM.dm, mapsDir);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    
    % Load the library, open the connection to the driver, and get DM
    % struct needed for some functions and some useful settings.
    % Open the driver and retrieve DM info struct
    try
        [err_code, B.bench.DM.dm] = BMCOpenDM(serialNumber, B.bench.DM.dm);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    catch 
        disp('Closing current connection...');
        hcst_cleanUpDM(B);
        disp('Opening a new one...');
        [err_code, B.bench.DM.dm] = BMCOpenDM(serialNumber, B.bench.DM.dm);
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
    [err_code, lut] = BMCGetDefaultMapping(B.bench.DM.dm);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end
    B.bench.DM.lut = lut;

    B.bench.DM.Nact = 952;
    B.bench.DM.NactAcross = 34;
    B.bench.DM.dac_scale = (2^16)-1; % Electronics are 16 bit
    B.bench.DM.MAX_V = 300;% Max voltage for electronics 
    B.bench.DM.V2bits = B.bench.DM.dac_scale/B.bench.DM.MAX_V;
    B.bench.DM.cmdLength = B.bench.DM.dm.size; % Length of command arrays to send
    
    B.bench.DM.flatvec = hcst_DM_flattenDM_BMCmap(B, false);

    B.bench.DM.CONNECTED = true;
end

