function resPos = hcst_LS_move(B,pos)
%hcst_LS_move Function to move the LS to an absolute position (in mm)
%   
%   - Uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   - It blocks execution until all axes are done moving
%   
%
%   Arguments/Outputs:
%   resPos = hcst_LS_move(bench, pos) moves the LS to the position
%       specified by 'pos'. 
%       'bench' is the struct containing all pertient bench information and
%           instances. It is created by the hcst_config() function.
%       'pos' is a 2-element vector with the target positions (in mm)
%           Values should be in the order:  [Vertical, Horizontal]
%           If an element in 'pos' is NaN, the corresponding axis will not
%           be moved
%       'resPos' is the resulting position of the two axes, in the same
%           order as pos.
%
%
%   Examples:
%       hcst_LS_move(bench, [8.8 45])
%           Moves the vertical axis to 8.8 and the horizontal axis to 45
%
%       hcst_LS_move(bench, [NaN 45])
%           Move only the horizontal axis (to 45)
%
%
%   See also: hcst_setUpBench, hcst_LS_getPos, hcst_cleanUpBench
%

M2MM = 1000;    %Conversion by which to multiply m to get mm

%% Check that the pos values are valid and within bounds; push otherwise
if ~isvector(pos) || length(pos) ~= 2
    error('Input positions must be a vector of length 2')
end

if pos(1) > B.bench.LS.VBOUND
    pos(1) = B.bench.LS.VBOUND;
end
if pos(2) > B.bench.LS.HBOUND
    pos(2) = B.bench.LS.HBOUND;
end

%% Move each axis in order
% Convert position values from mm to m (required for Zaber library)
pos = pos/M2MM;

% Move Vertical axis if needed
if ~isnan(pos(1))
    % Perform move and capture device error code
    try
        err = B.bench.LS.axV.moveabsolute(B.bench.LS.axV.Units.positiontonative(pos(1)));
    catch exception
        % Close port if a MATLAB error occurs, otherwise it remains locked
        fclose(B.bench.LS.axV.Protocol.Port);
        rethrow(exception);
    end
    % Throw error if a device error occurred
   	if ~isempty(err)
        error('An error occurred while moving the Vertical zaber\n  Error code = %d', err)
    end
end

% Query position for output; convert to mm
try
    resPos(1) = B.bench.LS.axV.Units.nativetoposition(B.bench.LS.axV.getposition)*M2MM;
catch exception
    % Close port if a MATLAB error occurs, otherwise it remains locked
    fclose(B.bench.LS.axV.Protocol.Port);
    rethrow(exception);
end

% Move Horizontal axis if needed
if ~isnan(pos(2))
    % Perform move and capture device error code
    try
        err = B.bench.LS.axH.moveabsolute(B.bench.LS.axH.Units.positiontonative(pos(2)));
    catch exception
        % Close port if a MATLAB error occurs, otherwise it remains locked
        fclose(B.bench.LS.axH.Protocol.Port);
        rethrow(exception);
    end
    % Throw error if a device error occurred
   	if ~isempty(err)
        error('An error occurred while moving the Horizontal zaber\n  Error code = %d', err)
    end
end

% Query position for output; convert to mm
try
    resPos(2) = B.bench.LS.axH.Units.nativetoposition(B.bench.LS.axH.getposition)*M2MM;
catch exception
    % Close port if a MATLAB error occurs, otherwise it remains locked
    fclose(B.bench.LS.axH.Protocol.Port);
    rethrow(exception);
end

end