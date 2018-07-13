function resPos = hcst_FPM_move(bench,pos)
%hcst_FPM_move Function to move the FPM to an absolute position (in mm)
%   
%   - This function uses the Conex.py class
%   - It does not move an axis beyond its #BOUND value; if you provide a
%       value that is larger than #BOUND, it will be pushed to #BOUND
%   - It blocks execution until all axes are done moving
%   
%
%   Arguments/Outputs:
%   resPos = hcst_FPM_move(bench, pos) moves the FPM to the position
%       specified by 'pos'. 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%       'pos' is a 3-element vector with the target positions (in mm)
%           Values should be in the order:  [Vertical, Horizontal, Focus]
%           If an element in 'pos' is NaN, the corresponding axis will not
%           be moved
%       'resPos' is the resulting position of the three axes, in the same
%           order as pos.
%
%
%   Examples:
%       hcst_FPM_move(bench, [.7 4 8])
%           Moves the vert. axis to .7, hor. axis to 4, and foc. axis to 8
%
%       hcst_FPM_move(bench, [.7 NaN NaN])
%           Move only the vertical axis (to .7)
%
%       hcst_FPM_move(bench, [.7 NaN 8])
%           Moves the vert. axis to .7 and foc. axis to 8 BUT leaves the
%           hor. axis unmoved.
%
%
%   See also: hcst_setUpBench, hcst_FPM_getPos, hcst_cleanUpBench
%


%% Check that the pos values are valid and within bounds; push otherwise
if ~isvector(pos) || length(pos) ~= 3
    error('Input positions must be a vector of length 3')
end

if pos(1) > bench.FPM.VBOUND
    pos(1) = bench.FPM.VBOUND;
end
if pos(2) > bench.FPM.HBOUND
    pos(2) = bench.FPM.HBOUND;
end
if pos(3) > bench.FPM.FBOUND
    pos(3) = bench.FPM.FBOUND;
end

%% move each axis in order
% Use blocking (true) to ensure move is complete before continuing script
% Do not move axes for which pos is nan

if ~isnan(pos(1))
    resPos(1) = bench.FPM.axV.moveAbs(pos(1), true);
else
    resPos(1) = bench.FPM.axV.reqPosAct();
end

if ~isnan(pos(2))
    resPos(2) = bench.FPM.axH.moveAbs(pos(2), true);
else
    resPos(2) = bench.FPM.axH.reqPosAct();
end

if ~isnan(pos(3))
    resPos(3) = bench.FPM.axF.moveAbs(pos(3), true);
else
    resPos(3) = bench.FPM.axF.reqPosAct();
end

end