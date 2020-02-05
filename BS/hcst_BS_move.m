function resPos = hcst_BS_move(bench,pos)
%hcst_BS_move Function to move the BS to an absolute position (in mm)
%   
%   - Uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   - It blocks execution until all axes are done moving
%   
%
%   Arguments/Outputs:
%   resPos = hcst_BS_move(bench, pos) moves the BS to the position
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
%       hcst_BS_move(bench, [8.8 45])
%           Moves the vertical axis to 8.8 and the horizontal axis to 45
%
%       hcst_BS_move(bench, [NaN 45])
%           Move only the horizontal axis (to 45)
%
%
%   See also: hcst_setUpBench, hcst_BS_getPos, hcst_cleanUpBench
%

M2MM = 1000;    %Conversion by which to multiply m to get mm

%% Check that the pos values are valid and within bounds; push otherwise
if ~isvector(pos) || length(pos) ~= 1
    error('Input positions must be a vector of length 1')
end

if pos > bench.BS.BOUND
    pos = bench.BS.BOUND;
end
%% Move each axis in order
% Convert position values from mm to m (required for Zaber library)
pos = pos/M2MM;

% Move Vertical axis if needed
if ~isnan(pos(1))
    % Perform move and capture device error code
    try
        err = bench.BS.ax.moveabsolute(bench.BS.ax.Units.positiontonative(pos(1)));
    catch exception
        % Close port if a MATLAB error occurs, otherwise it remains locked
        fclose(bench.BS.ax.Protocol.Port);
        rethrow(exception);
    end
    % Throw error if a device error occurred
   	if ~isempty(err)
        error('An error occurred while moving the Vertical zaber\n  Error code = %d', err)
    end
end

% Query position for output; convert to mm
try
    resPos = bench.BS.ax.Units.nativetoposition(bench.BS.ax.getposition)*M2MM;
catch exception
    % Close port if a MATLAB error occurs, otherwise it remains locked
    fclose(bench.BS.ax.Protocol.Port);
    rethrow(exception);
end

end