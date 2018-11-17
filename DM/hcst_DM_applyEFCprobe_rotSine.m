function [diffCmds2D,fullcmds1D] = hcst_DM_applyEFCprobe_rotSine( bench, ProbeArea, rot_ang,psix,psiy, PTV, apply )
%[cmds2D,cmds1D] = hcst_DM_applyEFCprobe( bench, ProbeArea, psi, PTV, apply )
% Applies or returns Give'on style DM probes for EFC

    flatvec = bench.DM.flatvec;
    offsetAct = bench.DM.offsetAct;
    
    Nact = bench.DM.NactAcross;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    % 459 is the central actuator
    xs = (-Nact/2:Nact/2-1)/Nact;
    [YS,XS] = meshgrid(xs);
    [THETA,RHO] = cart2pol(YS,XS);

    offsetX = offsetAct(1);
    offsetY = offsetAct(2);

%     offsetX = 0;
%     offsetY = 0;

    D = NactAcrossBeam / Nact;
    mx = (ProbeArea(2)-ProbeArea(1))/D;
    my = (ProbeArea(4)-ProbeArea(3))/D;
    wx = (ProbeArea(2)+ProbeArea(1))/2;
    wy = (ProbeArea(4)+ProbeArea(3))/2;

    %magn = lambda*sqrt(2*pi)*sqrt(InormDes);   % surface height (meters) to get desired intensity

    diffCmds2D = PTV*sinc(mx*(RHO.*cos(THETA-rot_ang)-offsetX/Nact)).*sinc(my*(RHO.*sin(THETA-rot_ang)-offsetY/Nact)).* ...
        cos(2*pi*wx/D*(RHO.*cos(THETA-rot_ang)-offsetX/Nact)-psix).*cos(2*pi*wy/D*(RHO.*sin(THETA-rot_ang)-offsetY/Nact)-psiy);
    diffCmds2D = diffCmds2D + min(diffCmds2D(:));
    
    
    data = hcst_DM_2Dto1D(bench,diffCmds2D);
    
    fullcmds1D = data+flatvec;
    
    if(apply)
        err_code = BMCSendData(bench.DM.dm, fullcmds1D);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    end
    
    

end

