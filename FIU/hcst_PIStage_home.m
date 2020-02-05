%% Comment:
% This will home the "axis" on an E-873 controller
% It takes the following variables:
    % 1) 'axis'         = char containing the axis name for use by other scripts
    % 2) 'PIdevice'     = instance of device (USB connection) object
% It will set the the servo switch on the stage to "ON" and leave it there
% This command will block until the reference completes
    % NOTE: a 60s timeout is implemented on the block

% function HCSTR_PIStage_home(axis, PIdevice)
function hcst_PIStage_home(bench)

axes = bench.FIUstages.stage.axes; %Copy axis vector for clarity

% switch servo on for axis
switchOn = 1;
for idx = 1:length(axes)
    bench.FIUstages.stage.PIdevice.SVO(axes(idx), switchOn);
end
% PIdevice.SVO(axis, switchOn);

% find reference point for each axis
for idx = 1:length(axes)
    bench.FIUstages.stage.PIdevice.FRF(axes(idx));
end
% PIdevice.FRF(axis);  % find reference

fprintf('Referencing (homing) axes...')
% fprintf('Referencing (homing) axis %s\n',axis)
% wait for referencing to finish
tic % implement timeout to avoid infinite loop
ncnt = 1; %counter for time display
fprintf('-- time elaped [s]: 0; ')
while any(bench.FIUstages.stage.PIdevice.IsMoving())
% while(0 ~= PIdevice.qFRF(axis) == 0)                        
    pause(0.1);           
    if ~mod(ncnt, 50)
        % approx. 5s have passes, print so
        fprintf('%.0f; ', ncnt/10)
    end
    ncnt = ncnt + 1;
    if toc > 60
        error('\nAxes failed to home in 60 seconds')
%         error('\nStage on axis %s failed to home in 60 seconds',axis)
    end
end 
% print new line to clear time display line
fprintf('\nAxes referenced (homed)')
% fprintf('\nAxis %s referenced (homed)\n', axis)

clear switchOn ncnt

end