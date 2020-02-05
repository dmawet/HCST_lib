% hcst_circPolAtFPM_wDMprobes.m
%
% send DM probes to see how it looks like at the image plane for different
% rotations of QWP1, w/ LP2 & QWP2 out.
% method to build the probe shapes is based on falco, by AJ Riggs
%
% Jorge Llop - Nov 18, 2019

%--Number of actuators across DM surface (independent of beam for time being)

%% get testbed ready
frameSize = 128;
setUpBench4EFC

tint = 1e-2;

hcst_andor_setExposureTime(bench,tint);


vortexPos = [bench.FPM.VORTEX_V0, bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];
resPos = hcst_FPM_move(bench,vortexPos);

%% build mask
lambdaOverD = bench.andor.pixelPerLamOverD;
OWA = 10;
IWA = 6;
[X,Y] = meshgrid(-frameSize/2:frameSize/2-1); 
[THETA,RHO] = cart2pol(X,Y);
Q = zeros(frameSize,frameSize);
Q = and(RHO >= IWA*lambdaOverD, RHO <= OWA*lambdaOverD);
Q = and(Q, Y > 0);
Q = and(Q, abs(THETA-pi/2) < pi/3); % 60deg keystone about x-axis

evalnum = 5;
delta_r = (OWA-IWA)/evalnum;
Q_eval_mat = zeros(frameSize,frameSize,evalnum);
for II=1:evalnum
    IWAII = IWA+delta_r*(II-1);
    OWAII = IWA+delta_r*(II);
    Q_eval_mat(:,:,II) = and(RHO >= IWAII*lambdaOverD, RHO <= OWAII*lambdaOverD);
    Q_eval_mat(:,:,II) = and(Q_eval_mat(:,:,II), Y > 0);
    Q_eval_mat(:,:,II) = and(Q_eval_mat(:,:,II), abs(THETA-pi/2) < pi/3); 
end

%%
Nact = 34;
offsetX = 0;
offsetY = 0;
radius = Nact/2;
badAxis = 'x';
lambda0 = 775e-9;
InormDes = 5e-3;
psi = 0; % phase shift

gainmap = hcst_DM_1Dto2D(bench,flatvec);
gainmap = gainmap/max(gainmap(:));
gainmap(gainmap<0.5) = 0.5;
VtoH_mat = (4e-7*ones(Nact) * 2*sqrt(2)).*gainmap*1;

gainFudge = 1;

%--Coordinates in actuator space
xs = (-(Nact-1)/2:(Nact-1)/2)/Nact - round(offsetX)/Nact;
ys = (-(Nact-1)/2:(Nact-1)/2)/Nact - round(offsetY)/Nact;
[XS,YS] = meshgrid(xs,ys);


%--Generate the DM command for the probe
magn = 4*pi*lambda0*sqrt(InormDes);   % surface height to get desired intensity [meters]

numpsi = 6;
psi_arr = linspace(0,pi*3/2,numpsi);

hcst_DM_flattenDM( bench, true );% sets the DM to flatvec
im0 = hcst_andor_getImage(bench);

fig0 = figure('visible','off','color','w','Position', [10 10 400 400]);
filename = 'gif_hcst_circPolAtFPM_wDMprobes.gif';

numRot = 100;
delta_rot = 0.5;
% rotQWP1_arr = linspace(mi_rotQWP1-delta_rot,mi_rotQWP1+delta_rot,numRot);
rotQWP1_arr = linspace(0,340,numRot);
ampstd_arr = zeros(numRot,1)*nan; 
for KK=1:numRot
    
    %Move QWP1
    rotQWP1 = rotQWP1_arr(KK);
    hcst_LPQWP_move(bench,[nan,rotQWP1,nan,bench.LPQWP.posQWP2-45]);

    ampProbeSqd_tot = 0;
    for II=1:numpsi
        psi = psi_arr(II);
        mX = 2*radius;
        mY = radius;
        omegaY = radius/2;
        probeCmd = magn*sinc(mX*XS).*sinc(mY*YS).*cos(2*pi*omegaY*YS + psi);


        %--Option to use just the sincs for a zero phase shift. This avoids the
        % phase discontinuity along one axis (for this probe only!).
        if(psi==0)
            m = 2*radius;
            probeCmd = magn*sinc(m*XS).*sinc(m*YS);
        end

        probeCmd = gainFudge*probeCmd; % Scale the probe amplitude empirically if needed

        im_mat = zeros(frameSize,frameSize,2);
        sign_arr = [1,-1];
        for JJ=1:2
            dDM1Vprobe = sign_arr(JJ) * probeCmd./VtoH_mat; % Now in volts
            cmds = hcst_DM_apply2Dmap( bench, dDM1Vprobe, 1 );

            im_mat(:,:,JJ) = hcst_andor_getImage(bench);
        end
        ampProbeSqd = im_mat(:,:,1) + im_mat(:,:,2);    
        ampProbeSqd_tot = ampProbeSqd_tot +ampProbeSqd;
    end
    imagesc(log10_4plot(ampProbeSqd_tot.*Q),[3,4.5])
    axis image
    title(['Rotation of QWP1: ',num2str(rotQWP1)])
    figure(fig0)
    frame = getframe(fig0); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,128); 
    %    Write to the GIF File 
    if KK==1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.5); 
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.5); 
    end
    
    % compute the std2 to see where there is circPol at the FPM
    ampstd_sum = 0;
    for ind_eval=1:evalnum
        auxmat = Q_eval_mat(:,:,ind_eval).*ampProbeSqd_tot;
        ampstd_sum = ampstd_sum + std2(auxmat(auxmat~=0));
    end
    ampstd_arr(KK) = ampstd_sum/evalnum;
    disp(['Std2: ',num2str(ampstd_arr(KK))])
end
figure(300)
plot(rotQWP1_arr,ampstd_arr)
xlabel('Rotation QWP1 [deg]')
ylabel('Std2')
hcst_disconnectDevices(bench, true, false)
%% Find min
[mi,ind_mi] = min(ampstd_arr);
mi_rotQWP1 = rotQWP1_arr(ind_mi);
disp(['Min Rot QWP1: ',num2str(mi_rotQWP1)])

%% Accept result
rotQWP1_minStd2 = mi_rotQWP1;
hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,nan,bench.LPQWP.posQWP2]);

%% Do a 2D search with QWP2 and LP2

hcst_DM_flattenDM( bench, true );% sets the DM to flatvec

% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

tint_arr2 = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1.5,2,3,5];
numtint = numel(tint_arr2);

dark0 = 0;
indtint = 5;
ma_peak = 76530000;

numRot = 5;
delta_ang = 0.1;
rot_arrLP2 = linspace(rotLP2_min-delta_ang,rotLP2_min+delta_ang,numRot);
rot_arrQWP2 = linspace(rotQWP2_min-delta_ang,rotQWP2_min+delta_ang,numRot);
% rot_arrLP2 = linspace(0,339,numRot);
% rot_arrQWP2 = linspace(0,339,numRot);
peak_mat = zeros(numRot)*nan;
for II=1:numRot
    rotLP2 = rot_arrLP2(II);
    count = 1;
    while 1
        tint = tint_arr2(indtint);
        hcst_andor_setExposureTime(bench,tint);
        
        rotQWP2 = rot_arrQWP2(count);
        pos = hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,rotLP2,rotQWP2]);
        im0 = hcst_andor_getImage(bench) - dark0;
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         im0 = im0 - median(im0(:));
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        peak = max(im0(:));

        figure(112);
        imagesc(log10_4plot(im0/2^16));
        axis image; 
        colorbar;%caxis([-4 0]);
        title([num2str(II),' - ',num2str(count)],'FontSize',32)
    %     text(10,10,num2str(peak_rel),'Color','w','FontSize',32);
        text(10,3,num2str(peak),'Color','w','FontSize',32);
        drawnow;
        if peak>60e3
            if indtint>1
                indtint = indtint-1;
            end
            disp('Exposure too high!')
        elseif peak<500
            if indtint<numtint
                indtint = indtint+1;
            end
            disp('Exposure too low!')
        else
            peak_mat(II,count) = peak/tint;
            count = count+1;
        end
        figure(203)
        imagesc(rot_arrQWP2,rot_arrLP2,peak_mat/ma_peak)
        axis image;
        xlabel('Rot QWP2 [deg]')
        ylabel('Rot LP2 [deg]')
        colorbar
        drawnow
        if count>numRot; break; end
    end
end
ma = max(peak_mat(:));
peak_norm_mat = peak_mat/ma_peak;
[mi,ind_mi] = min(peak_mat(:)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
[ind_x,ind_y] = ind2sub(size(peak_mat),ind_mi);
disp(['LP2 rot: ', num2str(rot_arrLP2(ind_x)),' QWP2 rot: ', num2str(rot_arrQWP2(ind_y))])
colorbar

%% Accept min result (or chose one)
% rotLP2_min = 197.8;
% rotQWP2_min = 98.88;
rotLP2_min = rot_arrLP2(ind_x);
rotQWP2_min = rot_arrQWP2(ind_y);
hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,rotLP2_min,rotQWP2_min]);

%% Accept final result
bench.LPQWP.posLP1 = bench.LPQWP.axLP1.reqPosAct();
bench.LPQWP.posQWP1 = rotQWP1_minStd2;
bench.LPQWP.posLP2 = rotLP2_min;
bench.LPQWP.posQWP2 = rotQWP2_min;
disp(['Min extinction ratio: ', num2str(peak/ma_peak)])
disp(['LP1 rot: ', num2str(bench.LPQWP.posLP1)])
disp(['QWP1 rot: ', num2str(bench.LPQWP.posQWP1)])
disp(['LP2 rot: ', num2str(bench.LPQWP.posLP2)])
disp(['QWP2 rot: ', num2str(bench.LPQWP.posQWP2)])
% hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,rotLP2_min,rotQWP2_min]);
hcst_LPQWP_move(bench,[bench.LPQWP.posLP1,bench.LPQWP.posQWP1,bench.LPQWP.posLP2,bench.LPQWP.posQWP2]);


%% Check polarization contrast, i.e. the ratio between going thru the empty slot and going thru the VVC


% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

tint = 0.1;
hcst_andor_setExposureTime(bench,tint);
im0 = hcst_andor_getImage(bench) - dark0;
peak_crossed = max(im0(:))/tint;

% filter position
hcst_FW_setPos(bench,2);% Focus viewing mode
NDfilter_cal = 21.2938 * 4.4506;

% Move to VVC mask
hcst_FPM_move(bench,[1 ,1, bench.FPM.VORTEX_F0]);
indtint = 2;
while 1
    tint = tint_arr2(indtint);
    hcst_andor_setExposureTime(bench,tint);

    im0 = hcst_andor_getImage(bench) - dark0;

    peak = max(im0(:));

    figure(112);
    imagesc(log10_4plot(im0/2^16));
    axis image; 
    colorbar;%caxis([-4 0]);
%     title([num2str(count)],'FontSize',32)
    text(10,3,num2str(peak),'Color','w','FontSize',32);
    drawnow;
    if peak>60e3
        if indtint>1
            indtint = indtint-1;
        else
            break
        end
        disp('Exposure too high!')
    elseif peak<500
        if indtint<numtint
            indtint = indtint+1;
        end
        disp('Exposure too low!')
    else
        peak_vvc = peak/tint;
        break
    end
end

polContrast = peak_crossed/(peak_vvc*NDfilter_cal);

disp(['Polarization contrast: ',num2str(polContrast)])
