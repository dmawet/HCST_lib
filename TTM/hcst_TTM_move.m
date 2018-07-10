function resPos = hcst_TTM_move(B,pos)
%hcst_TTM_move Function to move the TTM to an absolute position (in mrad)
%   
%   - This function uses the PI MATLAB driver
%   - It blocks execution until all axes are done moving
%   
%
%   Arguments/Outputs:
%   resPos = hcst_TTM_move(bench, pos) moves the TTM to the position
%       specified by 'pos'. 
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%       'pos' is a 2-element vector with the target positions (in mrad)
%           Values should be in the order:  [Channel 1(A), Channel 2(B)]
%           If an element in 'pos' is NaN, the corresponding axis will not
%           be moved
%       'resPos' is the resulting position of the two axes, in the same
%           order as pos.
%
%
%   Examples:
%       hcst_TTM_move(bench, [4.831 5])
%           Moves Channel 1(A) to 4.831 and Channel 2(B) to 5
%
%       hcst_FPM_move(bench, [NaN 5])
%           Move only Channel 2(B) to 5, leaves Channel 1(A) untouched
%
%
%   See also: hcst_setUpBench, hcst_TTM_getPos, hcst_cleanUpBench
%


%% Check that the pos values are valid
if ~isvector(pos) || length(pos) ~= 2
    error('Input positions must be a vector of length 2')
end

%% move axes
% Use blocking to ensure move is complete before continuing script
% Do not move axes for which pos is nan

axes = B.bench.TTM.stage.axes;    %Copy axes to use shorter name for clarity
axMod = B.bench.TTM.stage.axMod;  %Copy vector of activated axes for clarity

% Check if either axis should move and if that axis was activated
if any(~isnan(pos) & axMod(1:2))
    % Pick out which axes to move based on which values in pos are not NaN
    %   and whether that axis was activated
    ax2Move = strjoin(axes(~isnan(pos) & axMod(1:2)));
    % Pick out values for axes to be moved
    pos2Move = pos(~isnan(pos) & axMod(1:2));
    
    % Perform the move
    B.bench.TTM.stage.PIdevice.MOV(ax2Move, pos2Move);
    
    %wait for motion to stop
    while any(B.bench.TTM.stage.PIdevice.IsMoving(ax2Move))
        pause(0.001);   %very short pause to prevent uneccessary wait time
    end
end

% Query positions after move
resPos = B.bench.TTM.stage.PIdevice.qPOS(strjoin(axes(1:2)))';

end