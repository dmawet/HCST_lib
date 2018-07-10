function hcst_LS_home(B, homeFlg)
%hcst_LS_home Function to home the given axes of the LS
%   
%   - Uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   - It blocks execution until all axes are done homing
%   
%
%   Arguments/Outputs:
%   hcst_LS_home(bench, homeFlg) homes the LS axes specified by 'homeFlg' 
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%       'homeFlg' is a vector of logicals specifying which axes to home
%           The axes are in the order: [Vertical, Horizontal]
%
%
%   Examples:
%       hcst_LS_home(bench, [1 1])
%           Homes both axes
%
%       hcst_FPM_home(bench, [0 1])
%           Homes only the horizontal axis
%
%
%   See also: hcst_setUpBench, hcst_LS_move, hcst_LS_getPos,
%               hcst_cleanUpBench
%

%% Check that homeFlg is valid
if ~isvector(homeFlg) || length(homeFlg) ~= 2
    error('Input axes to home must be a vector of length 2')
end
%% Home the axes as needed

% use homeFlg == true (vs. just homeFlg) to implicitly check that a valid
% logical value was given.
if homeFlg(1) == true
    try
        B.bench.LS.axV.home();
    catch exception
        % Close port if a MATLAB error occurs, otherwise it remains locked
        fclose(B.bench.LS.axV.Protocol.Port);
        rethrow(exception);
    end
end
if homeFlg(2) == true
    try
        B.bench.LS.axH.home();
    catch exception
        % Close port if a MATLAB error occurs, otherwise it remains locked
        fclose(B.bench.LS.axH.Protocol.Port);
        rethrow(exception);
    end
end
end