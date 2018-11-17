function [Z,cmds] = hcst_DM_applyZernike( bench, noll_index, PTV, apply )
%[Z, cmds] = hcst_DM_applyZernike( bench, noll_index, PTV, apply )
%Applies Zernike polynomial to the DM

    flatvec = bench.DM.flatvec;
%     offsetAct = bench.DM.offsetAct;

    NactAcross = bench.DM.NactAcross;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    % 459 is the central actuator
    [XS,YS] = meshgrid((1:NactAcross)-bench.DM.xc,(1:NactAcross)-bench.DM.yc);

%     xs = (1:NactAcross)-(NactAcross+1)/2;
%     [XS,YS] = meshgrid(xs);
    [THETA,RHO] = cart2pol(XS,YS);

    [ Z, n, m ] = generateZernike( noll_index, NactAcrossBeam/2+1, RHO, THETA  );
    Z = sign(PTV)*Z;
    Z = Z - min(Z(:));
    Z = Z/max(Z(:));
    Z = abs(PTV)*Z;
    Z(isnan(Z)) = 0;
    
    data = hcst_DM_2Dto1D(bench,Z);
    
    cmds = data+flatvec;
    
    if(apply)
        err_code = BMCSendData(bench.DM.dm, cmds);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    end
    
    

end

