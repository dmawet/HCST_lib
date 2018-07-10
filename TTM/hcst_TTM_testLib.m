function hcst_TTM_testLib(B)
%hcst_TTM_testLib Function to test the TTM commands
%
%   CAUTION: This function WILL move the TTM. However, it will return it to
%   it's original position afterwards.
%   
%
%   Arguments/Outputs:
%   hcst_TTM_testLib(bench) test the various TTM commands 
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_TTM_testLib(bench)
%           Runs through the available MATLAB TTM commands
%
%
%   See also: hcst_testLib, hcst_setUpBench, hcst_cleanUpBench
%


%% Execute the functions/commands, one-by-one

% Query current position and store/display value
curPos  = hcst_TTM_getPos(B);
dispPos = sprintf('%09.6f ', curPos);
fprintf('Current positions: %s\n', dispPos)

% Move all axes by +.1 from current position
newPos = curPos + .1;
newPos = hcst_TTM_move(B, newPos);
dispPos = sprintf('%09.6f ', newPos);
fprintf('Axes moved to: %s\n', dispPos)

% Return axes to original position
newPos = hcst_TTM_move(B, curPos);
dispPos = sprintf('%09.6f ', newPos);
fprintf('Final axis positions: %s\n', dispPos)