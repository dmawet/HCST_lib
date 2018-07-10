function [Z,cmds] = hcst_DM_applyZernike( B, noll_index, PTV, apply )
%bench = hcst_DM_applyZernike( bench, noll_index, offsetAct, PTV )
%Applies Zernike polynomial to the DM

    flatvec = B.bench.DM.flatvec;
    offsetAct = B.bench.DM.offsetAct;
    
    NactAcross = B.bench.DM.NactAcross;
    NactAcrossBeam = B.bench.DM.NactAcrossBeam;
    % 459 is the central actuator
    xs = (1:NactAcross)-(NactAcross+1)/2;
    [XS,YS] = meshgrid(xs);
    [THETA,RHO] = cart2pol(XS-offsetAct(1),YS-offsetAct(2));

    [ Z, n, m ] = generateZernike( noll_index, NactAcrossBeam/2+1, RHO, THETA  );
    Z = sign(PTV)*Z;
    Z = Z - min(Z(:));
    Z = Z/max(Z(:));
    Z = abs(PTV)*Z;
    Z(isnan(Z)) = 0;
    
    data = hcst_DM_2Dto1D(B,Z);
    
    cmds = data+flatvec;
    
    if(apply)
        err_code = BMCSendData(B.bench.DM.dm, cmds);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    end
    
    

end

