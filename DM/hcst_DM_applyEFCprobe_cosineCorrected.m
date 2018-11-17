function [diffCmds2D,fullcmds1D] = hcst_DM_applyEFCprobe_cosineCorrected( bench, ProbeArea, psi, PTV, apply )
%[cmds2D,cmds1D] = hcst_DM_applyEFCprobe( bench, ProbeArea, psi, PTV, apply )
% Applies or returns Give'on style DM probes for EFC

    flatvec = bench.DM.flatvec;
    offsetAct = bench.DM.offsetAct;
    
    Nact = bench.DM.NactAcross;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    % 459 is the central actuator

    [XS,YS] = meshgrid(((1:Nact)-bench.DM.xc)/Nact,((1:Nact)-bench.DM.yc)/Nact);
    [THETA,RHO] = cart2pol(XS,YS);
    

    D = NactAcrossBeam / Nact;
    mx = (ProbeArea(2)-ProbeArea(1))/D;
    my = (ProbeArea(4)-ProbeArea(3))/D;
    wx = (ProbeArea(2)+ProbeArea(1))/2;
    wy = (ProbeArea(4)+ProbeArea(3))/2;

    %magn = lambda*sqrt(2*pi)*sqrt(InormDes);   % surface height (meters) to get desired intensity

    diffCmds2D = PTV*sinc(mx*XS).*sinc(my*YS).* ...
        cos(2*pi*wx/D*XS + psi).*cos(2*pi*wy/D*YS);
%     diffCmds2D = diffCmds2D/max(diffCmds2D(:))*PTV;
    %diffCmds2D = diffCmds2D - min(diffCmds2D(:));
    
    diffCmds2D = diffCmds2D.*cos(8*THETA);
    
    data = hcst_DM_2Dto1D(bench,diffCmds2D');
    
    fullcmds1D = data+flatvec;
    
    if(apply)
        err_code = BMCSendData(bench.DM.dm, fullcmds1D);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    end
    
    

end

