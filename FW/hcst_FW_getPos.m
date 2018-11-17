function pos = hcst_FW_getPos(bench)
%hcst_FW_getPos(bench,pos)
% Function to query the position of the FW. Also stored in bench.FW.pos
%   
%   - This function uses fw102c.py
%   
%
%   Arguments/Outputs:
%   pos = hcst_FW_getPos(bench) queries the FW for its position
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%       'pos' is a integer (1-6)
%
%
%   Examples:
%       hcst_FPM_move(bench)
%           returns the current FW position 
%
    
    pos = bench.FW.pyObj.query('pos?');
	pos = uint8(int64(py.int(pos)));% Convert the python data type to matlab
    
    bench.FW.currentPos = pos;
    
end