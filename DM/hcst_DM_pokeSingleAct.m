function cmds = hcst_DM_pokeSingleAct( B, act_num, cmd )
%[bench,cmds] = hcst_DM_pokeSingleAct( bench, act_num, cmd )
%Pokes a single DM actuator. act_num is the actuator numbers. cmd is the
%command to send, superimposed on the flat map. 

    flatvec = B.bench.DM.flatvec;
    
    
    data = zeros(1,B.bench.DM.cmdLength);
    data(act_num) = cmd;
    
    cmds = data+flatvec;
    
    err_code = BMCSendData(B.bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

end

