function hcst_cleanUpBench(B)
%hcst_cleanUpBench Function to close all control objects
%   
%   - This function closes the connection to the following bench elements:
%       (in order):
%       1) FPM
%       2) LS
%       3) TTM
%       4) Andor
%   
%   - TODO (in no particular order):
%       Add DM; save config file (with time stamp)
%
%
%   Arguments/Outputs:
%   bench = hcst_cleanUpBench(bench)
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_cleanUpBench(bench)
%           Returns an updated 'bench' struct
%
%
%   See also: hcst_config, hcst_setUpBench, hcst_cleanUpFPM
%

sucFlg = true;      %Flag to mark successful completion

%% Call the hardware cleanUp functions

% FPM
hcst_cleanUpFPM(B);
if any(isfield(B.bench.FPM, {'axV', 'axH', 'axF'}))
    fprintf('FPM did not close correctly\n')
    % Mark unsuccessful completion
    sucFlg = false;
else
    fprintf('FPM closed correctly\n')
end

% LS
hcst_cleanUpLS(B);
if any(isfield(B.bench.LS, {'axV', 'axH'}))
    fprintf('LS did not close correctly\n')
    % Mark unsuccessful completion
    sucFlg = false;
else
    fprintf('LS closed correctly\n')
end

% TTM
hcst_cleanUpTTM(B);
if isfield(B.bench.TTM, 'stage')
    fprintf('TTM did not close correctly\n')
    % Mark unsuccessful completion
    sucFlg = false;
else
    fprintf('TTM closed correctly\n')
end

% Andor 
hcst_cleanUpAndor(B);

%% Final Print
if sucFlg
    fprintf('\ncleanUpBench completed succesfully\n')
else
    fprintf('\nSomething did not close correctly\n')
end



% NOTE: when saving the conf file, we should save the current positions of
% the devices as User_#0 so that the devices will be returned to that pos

end