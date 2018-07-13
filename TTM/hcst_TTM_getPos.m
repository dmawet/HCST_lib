function resPos = hcst_TTM_getPos(bench)
%hcst_TTM_getPos Function to get the position of the TTM (in mrad)
%   
%   - This function uses the PI MATLAB driver
%   
%
%   Arguments/Outputs:
%   resPos = hcst_FPM_getPos(bench) gets the TTM position (in mrad)
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%       'resPos' is a vector with the position of the axes, in the order:
%           [Channel 1(A), Channel 2(B)]
%
%
%   Examples:
%       hcst_TTM_getPos(bench)
%           Returns the position of both axes (in mrad)
%
%
%   See also: hcst_setUpBench, hcst_TTM_move, hcst_cleanUpBench
%

%% get the position of each axis
resPos = bench.TTM.stage.PIdevice.qPOS(strjoin(bench.TTM.stage.axes(1:2)))';

end