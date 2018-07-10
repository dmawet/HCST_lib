function cmds = hcst_DM_applySine( B, spatFreq_r, spatFreq_q, PTV, phz )
%bench = hcst_DM_applySine( bench )

    flatvec = B.bench.DM.flatvec;
    NactAcross = B.bench.DM.NactAcross;
    NactAcrossBeam = B.bench.DM.NactAcrossBeam;
    
    xs = (1:NactAcross)-(NactAcross+1)/2;
    [XS,YS] = meshgrid(xs);
    [THETA,RHO] = cart2pol(XS,YS);
    
    %ripple = PTV*(0.5*sin(2*pi*RHO.*cos(THETA-spatFreq_q/180*pi)*spatFreq_r/NactAcrossBeam - phz)+0.5);
    ripple = PTV*sin(2*pi*RHO.*cos(THETA-spatFreq_q/180*pi)*spatFreq_r/NactAcrossBeam - phz);
    
    data = hcst_DM_2Dto1D(B,ripple);
    
    cmds = data+flatvec;
    

    err_code = BMCSendData(B.bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

    
end

