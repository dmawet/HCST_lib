function hcst_setUpBench(B)
%hcst_setUpBench Function to activate and instantiate control objects
%   
%   - This function should be called after hcst_config and before calling 
%       any other hcst_ functions
%   - It instantiates the following elements on the bench:
%       (in order):
%       1) FPM
%       2) LS
%       3) TTM
%       4) Andor
%   
%   - TODO (in no particular order):
%       Add DM
%
%
%   Arguments/Outputs:
%   bench = hcst_setUpBench(bench)
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpBench(bench)
%           Returns a fully populated 'bench' struct
%
%
%   See also: hcst_config, hcst_cleanUpBench
%

%% Call the hardware setUp functions

% FPM
hcst_setUpFPM(B);

% LS
hcst_setUpLS(B);

% TTM
hcst_setUpTTM(B);

% Andor Neo Camera
hcst_setUpAndor(B);


end