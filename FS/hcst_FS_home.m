function hcst_FS_home(bench, homeFlg)
%hcst_FS_home Function to home the given axes of the FS
%   
%   - This function uses the Conex.py class
%   - It blocks execution until all axes are done homing
%   
%
%   Arguments/Outputs:
%   hcst_FS_home(bench, homeFlg) homes the FS axes specified by 'homeFlg' 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%       'homeFlg' is a vector of logicals specifying which axes to home
%           The axes are in the order: [Vertical, Horizontal, Focus]
%
%
%   Examples:
%       hcst_FS_home(bench, [1 1 1])
%           Homes all axes
%
%       hcst_FS_home(bench, [0 1 0])
%           Homes only the horizontal axis
%
%       hcst_FS_home(bench, [1 1 0])
%           Homes the vertical and horizontal axes but not focus
%
%
%   See also: hcst_setUpBench, hcst_FS_move, hcst_FS_getPos,
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
    bench.FS.axV.home(true);
end
if homeFlg(2) == true
    bench.FS.axH.home(true);
end
if homeFlg(3) == true
    bench.FS.axF.home(true);
end
end