function hcst_setUpBench(bench)
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
%   hcst_setUpBench(B)
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpBench(B.bench)
%           Fully populates and updates the 'B.bench' struct.
%
%
%   See also: hcst_config, hcst_cleanUpBench
%

%% Call the hardware setUp functions

% FPM
hcst_setUpFPM(bench);

% LS
hcst_setUpLS(bench);

% TTM
hcst_setUpTTM(bench);

% Andor Neo Camera
hcst_setUpAndor(bench);


end