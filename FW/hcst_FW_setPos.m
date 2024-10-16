function resPos = hcst_FW_setPos(bench,pos)
%hcst_FW_setPos(bench,pos)
% Function to move the FW to a new position
%   
%   - This function uses fw102c.py
%   
%
%   Arguments/Outputs:
%   resPos = hcst_FW_setPos(bench, pos) moves the FW to the position
%       specified by 'pos'. 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%       'pos' is a integer (1-6)
%       'resPos' is the resulting position
%
%
%   Examples:
%       hcst_FPM_move(bench, 1)
%           Moves the FW to position 1
%

    curPos = hcst_FW_getPos(bench);
    
    if(curPos ~= pos)
    
        if(and(~isnan(pos), pos>=1 || pos<=6))
             bench.FW.pyObj.command(['pos=',num2str(round(pos))]);
            disp(['Filter wheel moved to position ',num2str(pos)]);
        else
            error('Invalid filter wheel position.');
        end

        %query('pos?')
        resPos = hcst_FW_getPos(bench);
    
    else
        resPos = curPos;
        disp(['Filter wheel at position ',num2str(pos)]);
    end
    

end