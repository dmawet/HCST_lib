function resPos = hcst_BSzaber_move(bench,pos)
%hcst_BSzaber_move Function to move the BSzaber to an absolute position (in mm)
%   
%   - Uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   - It blocks execution until all axes are done moving
%   
%
%   Arguments/Outputs:
%   resPos = hcst_BSzaber_move(bench, pos) moves the BSzaber to the position
%       specified by 'pos'. 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%       'pos' is a 2-element vector with the target positions (in mm)
%           Values should be in the order:  [Vertical, Horizontal]
%           If an element in 'pos' is NaN, the corresponding axis will not
%           be moved
%       'resPos' is the resulting position of the two axes, in the same
%           order as pos.
%
%
%   Examples:
%       hcst_BSzaber_move(bench, [8.8])
%           Moves the vertical axis to 8.8 and the horizontal axis to 45
%
%       hcst_BSzaber_move(bench, [NaN 45])
%           Move only the horizontal axis (to 45)
%
%
%   See also: hcst_setUpBench, hcst_BSzaber_getPos, hcst_cleanUpBench
%
import zaber.motion.ascii.*;
import zaber.motion.*;

M2MM = 1;    %Conversion by which to multiply m to get mm

%% Check that the pos values are valid and within bounds; push otherwise
if ~isvector(pos) || length(pos) ~= 1
    error('Input positions must be a vector of length 1')
end

if pos > bench.BSzaber.BOUND
    pos = bench.BSzaber.BOUND;
end
%% Move each axis in order
% Convert position values from mm to m (required for Zaber library)
pos = pos*M2MM;

% Move Vertical axis if needed
if ~isnan(pos(1))
    % Perform move and capture device error code
    try
        bench.BSzaber.axis.moveAbsolute(pos, Units.LENGTH_CENTIMETRES);
    catch exception
        % Close port if a MATLAB error occurs, otherwise it remains locked
        rethrow(exception);
    end
    % Throw error if a device error occurred
%    	if ~isempty(err)
%         error('An error occurred while moving the zaber\n  Error code = %d', err)
%     end
end

% Query position for output; convert to mm
try
    resPos = bench.BSzaber.axis.getPosition(Units.LENGTH_CENTIMETRES)*M2MM;
catch exception
    rethrow(exception);
end

end