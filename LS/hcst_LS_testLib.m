function hcst_LS_testLib(bench)
%hcst_LS_testLib Function to test the LS commands
%
%   CAUTION: This function WILL move the LS. However, it will return it to
%   it's original position afterwards.
%   
%
%   Arguments/Outputs:
%   hcst_LS_testLib(bench) test the various LS commands 
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_LS_testLib(bench)
%           Runs through the available MATLAB LS commands
%
%
%   See also: hcst_testLib, hcst_setUpBench, hcst_cleanUpBench
%


%% Execute the functions/commands, one-by-one

% Query current position and store/display value
curPos  = hcst_LS_getPos(bench);
dispPos = sprintf('%09.6f ', curPos);
fprintf('Current positions: %s\n', dispPos)

% Home vertical axis only
hcst_LS_home(bench, [true, false])
fprintf('Vertical axis homed\n')

% Move all axes by +.1 from current position (taking into accoung V homed)
newPos = curPos + .1; newPos(1) = .1;  %Handle V axis separetly since homed
newPos = hcst_LS_move(bench, newPos);
dispPos = sprintf('%09.6f ', newPos);
fprintf('Axes moved to: %s\n', dispPos)

% Return axes to original position
newPos = hcst_LS_move(bench, curPos);
dispPos = sprintf('%09.6f ', newPos);
fprintf('Final axis positions: %s\n', dispPos)