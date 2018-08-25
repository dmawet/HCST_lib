function hcst_setUpTTM(bench)
%hcst_setUpTTM Function to prepare the TTM for control
%   
%   - This function should be called before calling any other TTM functions
%   - It uses the PI MATLAB driver
%   - It does not activate/move the servos unless needed. If an axis servo
%       was disabled when this funciton is called, it will be enabled and
%       the given axis will be moved to bench.TTM.User_CH2_0
%   
%
%   Arguments/Outputs:
%   hcst_setUpTTM(bench) Instantiates the PI control classes.
%       Updates the TTM sub-struct which contains pertinent information 
%       about the stage as well as the instance of the PI Controller class. 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpTTM(bench)
%           Updates 'bench', the TTM sub-struct, and the requisite classes
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpTTM
%

%% Load PI MATLAB Driver GCS2
%  (if not already loaded)
if ( ~isfield(bench.TTM,'stage') || ...
        ~isfield(bench.TTM.stage, 'Controller') || ...
        ~isa(bench.TTM.stage.Controller, 'PI_GCS_Controller' ) )
    bench.TTM.stage.Controller = PI_GCS_Controller ();
end

%% Start connection
%(if not already connected)

% Check if PIdevice is connected
boolPIdeviceConnected = false; 
if ( isfield(bench.TTM.stage, 'PIdevice') )
    if ( bench.TTM.stage.PIdevice.IsConnected ), ...
            boolPIdeviceConnected = true; 
    end 
end

if ( ~(boolPIdeviceConnected ) )
    if bench.TTM.isTCPIP
        % TCP/IP
        port = 50000;           % 50000 for almost all PI controllers
        bench.TTM.stage.PIdevice = ... 
            bench.TTM.stage.Controller.ConnectTCPIP ...
            ( bench.TTM.IP_ADDRESS, port ) ;
    else
        % USB
        controllerSerialNumber = '116035074';
        bench.TTM.stage.PIdevice = ...
            bench.TTM.stage.Controller.ConnectUSB ...
            ( controllerSerialNumber );
    end
end

% Initialize PIdevice object
bench.TTM.stage.PIdevice = bench.TTM.stage.PIdevice.InitializeController();


%% Activate axes (Set ONLINE and CL operation)
%Query controller axes
availableaxes = bench.TTM.stage.PIdevice.qSAI_ALL; 

axCtl = [1 2 3];    %array of axes on our controller (for number indexing)
axMod = logical([1 1 0]);    %Axes to use (DO NOT ACTIVATE AX 3!)

%___Bring ONLINE
% Check if axes selected in axMod are already online
%   This is done to avoid setting ONL unneccessarily which could affect the
%   axis position.
isONL = logical(bench.TTM.stage.PIdevice.qONL(axCtl));  %ONL status of all axes
if any(isONL ~= axMod)
    % Axtivate servos of axes which are different from axMod
    for k = find(isONL ~= axMod)
        bench.TTM.stage.PIdevice.ONL(axCtl(k), axMod(k));
    end
end

%Confirm setting was accepted
isONL = logical(bench.TTM.stage.PIdevice.qONL(axCtl));  %ONL status of all axes
if any(isONL ~= axMod)
    % The reported ONL status of an axis differs from what we assigned
    errStr = "";    % error string containing incorrect-status-axes
    for k = find(isONL ~= axMod)
        % Find axes whose status differs; add to errStr
        errStr = errStr + sprintf("Axis %s's ONL status is incorrect\n", ...
            availableaxes{k});
    end
    
    % Close and clean-up instances of PI class
    bench.TTM.stage.PIdevice.CloseConnection;
    bench.TTM.stage.Controller.Destroy;
    bench.TTM = rmfield(bench.TTM, 'stage');
    
    % Throw error
    error(errStr)
end

%___Activate SERVOS
% Check if axes selected in axMod are already in Closed Loop mode
%   This is done to avoid setting SVO unneccessarily which could affect the
%   axis position.
isSVO = logical(bench.TTM.stage.PIdevice.qSVO');  %SVO status of all axes
if any(isSVO ~= axMod)
    % Axtivate servos of axes which are different from axMod
    for k = find(isSVO ~= axMod)
        bench.TTM.stage.PIdevice.SVO(availableaxes{k}, axMod(k));
        % Since servo was off, bring axis to User-provided position
        %   No k==3 case to avoid trying to move ax 3 if in case of error
        if k == 1
            bench.TTM.stage.PIdevice.MOV(availableaxes{k}, ...
                bench.TTM.User_CH1_0);
        elseif k == 2
            bench.TTM.stage.PIdevice.MOV(availableaxes{k}, ...
                bench.TTM.User_CH2_0);
        end
    end
end

%Confirm setting was accepted
isSVO = logical(bench.TTM.stage.PIdevice.qSVO');  %SVO status of all axes
if any(isSVO ~= axMod)
    % The reported SVO status of an axis differs from what we assigned
    errStr = "";    % error string containing incorrect-status-axes
    for k = find(isSVO ~= axMod)
        % Find axes whose status differs; add to errStr
        errStr = errStr + sprintf("Axis %s's SVO status is incorrect\n", ...
            availableaxes{k});
    end
    
    % Close and clean-up instances of PI class
    bench.TTM.stage.PIdevice.CloseConnection;
    bench.TTM.stage.Controller.Destroy;
    bench.TTM = rmfield(bench.TTM, 'stage');
    
    % Throw error
    error(errStr)
end

if axMod == logical(bench.TTM.stage.PIdevice.qONL(axCtl))
    bench.TTM.CONNECTED = true;
end

%% Populate struct
% NOTE: Controller and PIdevice are already added above
bench.TTM.stage.axes = availableaxes;
bench.TTM.stage.axCtl = axCtl;
bench.TTM.stage.axMod = axMod;

% Save backup bench object
hcst_backUpBench(bench)

end

