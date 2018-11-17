function [cmds,ripple] = hcst_DM_applySine( bench, spatFreq_r, spatFreq_q, PTV, phz )
%cmds = hcst_DM_applySine( bench, spatFreq_r, spatFreq_q, PTV, phz )

    flatvec = bench.DM.flatvec;
    NactAcross = bench.DM.NactAcross;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    
    xs = (1:NactAcross)-(NactAcross+1)/2;
    [XS,YS] = meshgrid(xs);
    [THETA,RHO] = cart2pol(XS,YS);
    
    %ripple = PTV*(0.5*sin(2*pi*RHO.*cos(THETA-spatFreq_q/180*pi)*spatFreq_r/NactAcrossBeam - phz)+0.5);
    ripple = PTV*sin(2*pi*RHO.*cos(THETA-spatFreq_q/180*pi)*spatFreq_r/NactAcrossBeam - phz);
    
    data = hcst_DM_2Dto1D(bench,ripple);
    
    cmds = data+flatvec;
    

    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

    
end

