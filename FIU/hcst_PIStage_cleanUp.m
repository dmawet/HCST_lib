%% Comment:
% This will close the connection to the E-873 controller
%
% NOTE: This will turn off the servo, thereby setting the axis to open-loop
%
% It takes the following variables
    % 1) 'axes'         = char containing the axis names for use by other scripts
    % 2) 'Controller'   = instance of controller object
    % 3) 'PIdevice'     = instance of device (USB connection) object

% function HCSTR_PIStage_cleanUp(axes, Controller, PIdevice)
function hcst_PIStage_cleanUp(bench)

%% Close the connections and populate the bench struct accordingly
bench.FIUstages.stage.PIdevice.CloseConnection;
bench.FIUstages.stage.Controller.Destroy;
if ~bench.FIUstages.stage.PIdevice.IsConnected
    % Remove the sub-struct only if successfully closed
    bench.FIUstages = rmfield(bench.FIUstages, 'stage');
    bench.FIUstages.CONNECTED = false;
end
disp('*** PI stages for FIU disconnected. ***')
% Save backup bench object
hcst_backUpBench(bench)

end

% %% Open servo
% for idx = 1:length(axes)
%     PIdevice.SVO(char(axes(idx)), 0);
% end
%     
% %% Close the connection
% PIdevice.CloseConnection();
% 
% %% Unload the dll and destroy the class object
% Controller.Destroy();
% clear Controller PIdevice axes

% end