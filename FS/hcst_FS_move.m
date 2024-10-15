function resPos = hcst_FS_move(bench,pos)
%hcst_FS_move Function to move the FS to an absolute position (in mm)
%   
%   - This function uses the Conex.py class
%   - It does not move an axis beyond its #BOUND value; if you provide a
%       value that is larger than #BOUND, it will be pushed to #BOUND
%   - It blocks execution until all axes are done moving
%   
%
%   Arguments/Outputs:
%   resPos = hcst_FS_move(bench, pos) moves the FS to the position
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
%       hcst_FS_move(bench, [.7 4 8])
%           Moves the vert. axis to .7, hor. axis to 4, and foc. axis to 8
%
%       hcst_FS_move(bench, [.7 NaN NaN])
%           Move only the vertical axis (to .7)
%
%       hcst_FS_move(bench, [.7 NaN 8])
%           Moves the vert. axis to .7 and foc. axis to 8 BUT leaves the
%           hor. axis unmoved.
%
%
%   See also: hcst_setUpBench, hcst_FS_getPos, hcst_cleanUpBench
%


%% Check that the pos values are valid and within bounds; push otherwise
if ~isvector(pos) || length(pos) ~= 3
    error('Input positions must be a vector of length 3')
end

if pos(1) > bench.FS.VBOUND
    pos(1) = bench.FS.VBOUND;
    error('FS: Vertical position out of range')
end
if pos(2) > bench.FS.HBOUND
    pos(2) = bench.FS.HBOUND;
    error('FS: Horizontal position out of range')
end
if pos(3) > bench.FS.FBOUND
    pos(3) = bench.FS.FBOUND;
    error('FS: Focus position out of range')
end

if pos(1) < 0
    pos(1) = 0;
    error('FS: Vertical position out of range')
end
if pos(2) < 0
    pos(2) = 0;
    error('FS: Horizontal position out of range')
end
if pos(3) < 0
    pos(3) = 0;
    error('FS: Focus position out of range')
end

%% move each axis in order
% Use blocking (true) to ensure move is complete before continuing script
% Do not move axes for which pos is nan

if ~isnan(pos(1))
    resPos(1) = bench.FS.axV.moveAbs(pos(1), true);
else
    resPos(1) = bench.FS.axV.reqPosAct();
end

if ~isnan(pos(2))
    resPos(2) = bench.FS.axH.moveAbs(pos(2), true);
else
    resPos(2) = bench.FS.axH.reqPosAct();
end

if ~isnan(pos(3))
    resPos(3) = bench.FS.axF.moveAbs(pos(3), true);
else
    resPos(3) = bench.FS.axF.reqPosAct();
end

end