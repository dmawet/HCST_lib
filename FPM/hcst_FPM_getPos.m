function resPos = hcst_FPM_getPos(bench)
%hcst_FPM_getPos Function to get the position of the FPM (in mm)
%   
%   - This function uses the Conex.py class
%   
%
%   Inputs:
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%   Outputs:
%       'resPos' is a vector with the position of the axes, in the order:
%           [Vertical, Horizontal, Focus]
%
%
%   Examples:
%       FPM_pos = hcst_FPM_getPos(bench)
%           Returns the position of all three axes (in mm)
%
%
%   See also: hcst_setUpBench, hcst_FPM_move, hcst_cleanUpBench
%

%% get the position of each axis
resPos(1) = bench.FPM.axV.reqPosAct();
resPos(2) = bench.FPM.axH.reqPosAct();
resPos(3) = bench.FPM.axF.reqPosAct();

end