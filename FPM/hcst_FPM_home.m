function hcst_FPM_home(bench, homeFlg)
%hcst_FPM_home Function to home the given axes of the FPM
%   
%   - This function uses the Conex.py class
%   - It blocks execution until all axes are done homing
%   
%
%   Arguments/Outputs:
%   hcst_FPM_home(bench, homeFlg) homes the FPM axes specified by 'homeFlg' 
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%       'homeFlg' is a vector of logicals specifying which axes to home
%           The axes are in the order: [Vertical, Horizontal, Focus]
%
%
%   Examples:
%       hcst_FPM_home(bench, [1 1 1])
%           Homes all axes
%
%       hcst_FPM_home(bench, [0 1 0])
%           Homes only the horizontal axis
%
%       hcst_FPM_home(bench, [1 1 0])
%           Homes the vertical and horizontal axes but not focus
%
%
%   See also: hcst_setUpBench, hcst_FPM_move, hcst_FPM_getPos,
%               hcst_cleanUpBench
%

%% Check that homeFlg is valid
if ~isvector(homeFlg) || length(homeFlg) ~= 3
    error('Input axes to home must be a vector of length 3')
end
%% Home the axes as needed

% use homeFlg == true (vs. just homeFlg) to implicitly check that a valid
% logical value was given.
if homeFlg(1) == true
    bench.FPM.axV.home(true);
end
if homeFlg(2) == true
    bench.FPM.axH.home(true);
end
if homeFlg(3) == true
    bench.FPM.axF.home(true);
end
end