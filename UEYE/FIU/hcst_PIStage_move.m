%% Comment:
% This will move the "axis" on an E-873 controller to position "PIpos" 
% It takes the following variables:
    % 1) 'axis'         = char containing the axis name for use by other scripts
    % 2) 'PIdevice'     = instance of device (USB connection) object
    % 3) 'PIpos'        = position to which the device should be moved
                        %   This should be a float in range (-13, 13) [mm]
% This command will block until the move completes
    % NOTE: a 60s timeout is implemented on the block

% function HCSTR_PIStage_move(axis, PIdevice, PIpos)
function hcst_PIStage_move(bench, pos)

%% Check that the pos values are valid
if ~isvector(pos) || length(pos) ~= 3
    error('Input positions must be a vector of length 3')
end

%% Perform move

axes = bench.FIUstages.stage.axes;    %Copy axes to use shorter name for clarity

%-- Check that axes has been referenced
for idx = 1:length(axes)
    if ~bench.FIUstages.stage.PIdevice.qFRF(axes(idx))
        error('Axis %s has not been referenced (homed). Call _home.m', axes(idx))
    end
end

%-- Check that servo is on for closed-loop move
% svoFlag = false;
for idx = 1:length(axes)
    if ~bench.FIUstages.stage.PIdevice.qSVO(axes(idx))
%         svoFlag = true;
        bench.FIUstages.stage.PIdevice.SVO(axes(idx), 1);
        warning('Servo was off for axis %s. Servo has been turned on for move', axes(idx))
    end
end

if any(~isnan(pos))
    % Pick out which axes to move based on which values in pos are not NaN
    ax2Move = axes(~isnan(pos));
    % Pick out values for axes to be moved
    pos2Move = pos(~isnan(pos)); 

    % Move in closed loop
    for idx = 1:length(ax2Move)
        bench.FIUstages.stage.PIdevice.MOV(ax2Move(idx), pos2Move(idx));
    end
    
    %wait for motion to stop
    while any(bench.FIUstages.stage.PIdevice.IsMoving())
        pause(0.001); %very short pause to prevent uneccessary wait time
    end
end

%-- Print final position
finPos = bench.FIUstages.stage.PIdevice.qPOS();
% disp('Final positions of axes')
% disp(finPos)

% if svoFlag
%     bench.FIUstages.stage.PIdevice.SVO(ax2Move, 0);
%     warning('Servo on axes %s was turned back off since it was off before the move', ax2Move)
% end

clear svoFlag finPos

% %% Perform move
% %-- Check that axis has been referenced
% if ~PIdevice.qFRF(axis)
%     error('Axis %s has not been referenced (home). Call _home.m', axis)
% end
% 
% %-- Check that servo is on for closed-loop move
% svoFlag = false;
% if ~PIdevice.qSVO(axis)
%     svoFlag = true;
%     PIdevice.SVO(axis, 1);
%     warning('Servo was off for axis %s. Servo has been turned on for move', axis)
% end
% 
% %-- Move in closed loop
% PIdevice.MOV (axis, PIpos);
% 
% % NEW BLOCKING FEATURE -- longer but more efficient
% fprintf('Moving axis %s\n', axis)
% % wait for move to finish
% tic % implement timeout to avoid infinite loop
% ncnt = 1; %counter for time display
% while(0 ~= PIdevice.IsMoving(axis))                        
%     pause(0.01);           
%     if ~mod(ncnt, 500)
%         if ncnt == 500
%             %Start printing on first call if needed
%             fprintf('-- time elaped [s]: ')
%         end
%         % approx. 5s have passes, print so
%         fprintf('%.0f; ', ncnt/100)
%     end
%     ncnt = ncnt + 1;
%     if toc > 60
%         error('\nStage on axis %s failed to move in 60 seconds', axis)
%     end
% end 
% % print new line to clear time display line
% fprintf('\n')
% 
% %-- Print final position
% finPos = PIdevice.qPOS(axis);
% fprintf('Axis %s moved to %f\n', axis, finPos)
% 
% if svoFlag
%     PIdevice.SVO ( axis, 0);
%     warning('Servo on axis %s was turned back off since it was off before the move', axis)
% end
% 
% clear svoFlag ncnt finPos

end