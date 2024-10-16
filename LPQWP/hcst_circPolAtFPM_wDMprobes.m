% hcst_circPolAtFPM_wDMprobes.m
%
% Find circular polarization at the FPM, in three steps:
% 1) send DM probes to see how it looks like at the image plane for different
% rotations of QWP1, w/ LP2 & QWP2 in random positions (rotations).
% method to build the probe shapes is based on falco, by AJ Riggs. 
% 2) with the chosen QWP1 position, rotate
%
% 
% Jorge Llop - Nov 18, 2019

%--Number of actuators across DM surface (independent of beam for time being)

%% get testbed ready
% Turn on NKT
% tb_NKT_setEmission(bench,fa0lse);
% tb_NKT_setEmission(bench,true);
lam0 = 775;
bw = 10;
pwr = 32;
lam1 = lam0 - bw/2;
lam2 = lam0 + bw/2;
tb_NKT_setWvlRange(bench,lam1,lam2);
tb_NKT_setPowerLevel(bench,pwr)
tb_NKT_setEmission(bench,true)

frameSize = 180;
setUpBench4EFC

centrow = bench.andor.FocusRow;
centcol = bench.andor.FocusCol;
hcst_andor_setSubwindow(bench,centrow,centcol,frameSize);

vortexPos = [bench.FPM.VORTEX_V0, bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];
resPos = hcst_FPM_move(bench,vortexPos);

% Move FS
% FSpos = [bench.FS.V2, bench.FS.H2, bench.FS.F2];
% FSpos = [bench.FS.V0, bench.FS.H0, bench.FS.F0];
% resPos = hcst_FS_move(bench,FSpos);

% Move FEU out of the way
% resPos = hcst_FEUzaber_move(bench,bench.FEUzaber.posOut);

hcst_FW_setPos(bench,1);% Focus viewing mode
disp('Done preparing for this test')
%% build mask
vortexPos = [bench.FPM.VORTEX_V0, bench.FPM.VORTEX_H0, bench.FPM.VORTEX_F0];
resPos = hcst_FPM_move(bench,vortexPos);

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

%% In case we already know where the min is
    mi_rotQWP1 = bench.LPQWP.posQWP1;
    rotQWP1_minStd2 = mi_rotQWP1;
%% In case we already know where the min is
    rotLP2_min=bench.LPQWP.posLP2;
    rotQWP2_min=bench.LPQWP.posQWP2;
%% Sweep QWP1
% With QWP2 and LP2 (circular analyzer) at random positions, send sinc probes with the DM for different rotations of QWP.

tint = 1e-2;
hcst_andor_setExposureTime(bench,tint);

Nact = 34;
radius = Nact/2;
badAxis = 'x';
lambda0 = 775e-9;
InormDes = 5e-3;
psi = 0; % phase shift

gainmap = hcst_DM_1Dto2D(bench,bench.DM.flatvec);
gainmap = gainmap/max(gainmap(:));
gainmap(gainmap<0.5) = 0.5;
VtoH_mat = (4e-7*ones(Nact) * 2*sqrt(2)).*gainmap*1;

gainFudge = 1;

%--Coordinates in actuator space
xs = (-(Nact-1)/2:(Nact-1)/2)/Nact;
ys = (-(Nact-1)/2:(Nact-1)/2)/Nact;
[XS,YS] = meshgrid(xs,ys);
% COORDINATES FEND
N = frameSize;
apRad = N/2; % Aperture radius (samples)
[X,Y] = meshgrid(-N/2:N/2-1); 
xvals = X(1,:);yvals = Y(:,1);
xisDL = xvals/bench.andor.numPixperCycle;
etasDL = yvals/bench.andor.numPixperCycle;


%--Generate the DM command for the probe
magn = 4*pi*lambda0*sqrt(InormDes);   % surface height to get desired intensity [meters]

numpsi = 6;
psi_arr = linspace(0,pi*3/2,numpsi);

hcst_DM_flattenDM( bench, true );% sets the DM to flatvec
im0 = hcst_andor_getImage(bench);

fig0 = figure('visible','off','color','w','Position', [10 10 400 400]);
% outdir = '/home/hcst/HCST_scripts/CharacterizeBench/output/circPolarizationAtFPM_SPIE2021/';
% filename = [ourdir,'gif_hcst_circPolAtFPM_wDMprobes.png'];

%********************************************************************************
numRot = 11;
delta_rot = 10;
rotQWP1_arr = linspace(mi_rotQWP1-delta_rot,mi_rotQWP1+delta_rot,numRot);
% rotQWP1_arr = linspace(0,339,numRot);
%********************************************************************************
ampstd_arr = zeros(numRot,1)*nan; 

% %%
% LPQWP_pos = [0.,rotQWP1_arr(1),bench.LPQWP.posLP2,bench.LPQWP.posQWP2+45];
% hcst_LPQWP_move(bench,LPQWP_pos);  
% disp('Done');
% %%
for KK=1:numRot
    
    %Move QWP1, with LP2 and QWP2 at random positions!
    rotQWP1 = rotQWP1_arr(KK);
    LPQWP_pos = [bench.LPQWP.posLP1,rotQWP1,bench.LPQWP.posLP2+15,bench.LPQWP.posQWP2-25];
    hcst_LPQWP_move(bench,LPQWP_pos);

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
            
            imJJ = hcst_andor_getImage(bench);
%             figure(111)
%             imagesc(log10_4plot(imJJ));
%             axis image
            
            im_mat(:,:,JJ) = imJJ;
        end
        ampProbeSqd = im_mat(:,:,1) + im_mat(:,:,2);    
        ampProbeSqd_tot = ampProbeSqd_tot +ampProbeSqd;
    end
    % Check if we have enough SNR
    im_tot = ampProbeSqd_tot.*Q;
%     im_tot = im_tot0(~isnan(im_tot0));
    me_int_tot = median(im_tot(Q));
    disp(['med image in DH: ',num2str(me_int_tot)])

    imagesc(xisDL,etasDL,log10_4plot(ampProbeSqd_tot.*Q),[3,4.5])
    axis image
    title(['Rotation of QWP1: ',num2str(rotQWP1)],'Interpreter','latex')
    xlabel('$\lambda_0$/D','Interpreter','LaTeX'); 
    ylabel('$\lambda_0$/D','Interpreter','LaTeX');
    figure(fig0)
%     frame = getframe(fig0); 
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,128); 
    %    Write to the GIF File 
%     if KK==1
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.5); 
%     else
%         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.5); 
%     end
%     filename = [outdir,'scanPic_rot',num2str(KK),'.png'];
%     export_fig(filename,'-r300');
    
    % compute the std2 to see where there is circPol at the FPM
    ampstd_sum = 0;
    for ind_eval=1:evalnum
        auxmat = Q_eval_mat(:,:,ind_eval).*ampProbeSqd_tot;
        ampstd_sum = ampstd_sum + std2(auxmat(auxmat~=0));
    end
    ampstd_arr(KK) = ampstd_sum/evalnum/me_int_tot;
    disp(['Std2: ',num2str(ampstd_arr(KK))])
    
end
figure(300)
plot(rotQWP1_arr,ampstd_arr)
xlabel('Rotation QWP1 [deg]')
ylabel('Std2')
% hcst_disconnectDevices(bench, true, false)
%% Find min
[mi,ind_mi] = min(ampstd_arr);
mi_rotQWP1 = rotQWP1_arr(ind_mi);
disp(['Min Rot QWP1: ',num2str(mi_rotQWP1)])

%% Accept result
rotQWP1_minStd2 = mi_rotQWP1;
% hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,nan,bench.LPQWP.posQWP2]);
hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,nan,nan]);

hcst_DM_zeroDM( bench );
bench.LPQWP.posQWP1 = mi_rotQWP1;
disp(['Result accepted'])


%% In case we already know where the min is
    mi_rotQWP1 = bench.LPQWP.posQWP1;
    rotQWP1_minStd2 = mi_rotQWP1;
%% In case we already know where the min is
    rotLP2_min=bench.LPQWP.posLP2;
    rotQWP2_min=bench.LPQWP.posQWP2;
%%
% rotLP2_min=189.2647;
% rotQWP2_min=133.3155;

%%
hcst_FW_setPos(bench,1);% Focus viewing mode
% hcst_FW_setPos(bench,2);% Focus viewing mode
%% Do a 2D search with QWP2 and LP2
% Move analyzer in
% hcst_DM_flattenDM( bench, true );% sets the DM to flatvec

% Go through the Zernike mask
hcst_FPM_move(bench,[bench.FPM.empty_slot_V , bench.FPM.empty_slot_H, nan]);

% tint_arr2 = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1.5,2,3,5];
tint_arr2 = [5e-5, 1e-4, 5e-4, 1e-3, 2.5e-3, 5e-3, 1e-2,1e-1, 5e-1, 1., 2.5, 5, 10, 20, 30];
numtint = numel(tint_arr2);

dark0 = 0;
indtint = 4;
ma_peak = 76530000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotLP2_min=210;
% rotQWP2_min=120;
% rotLP2_min=154.8801;
% rotQWP2_min=52.5544;
% rotLP2_min=bench.LPQWP.posLP2;
% rotQWP2_min=bench.LPQWP.posQWP2;
numRot = 5; %5;
delta_ang =2/5/5; %2/5; %2/5/5; %0.2;
rot_arrLP2 = linspace(rotLP2_min-delta_ang,rotLP2_min+delta_ang,numRot);
rot_arrQWP2 = linspace(rotQWP2_min-delta_ang,rotQWP2_min+delta_ang,numRot);
% rot_arrLP2 = linspace(0,339,numRot);
% rot_arrQWP2 = linspace(0,339,numRot);
% LPQWP_pos = [0.,rotQWP1_minStd2,rot_arrLP2(1),rot_arrQWP2(1)];
% hcst_LPQWP_move(bench,LPQWP_pos);  
% disp('Done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        

        peak = max(im0(:));

        figure(112);
        imagesc(log10_4plot(im0/2^16));
        axis image; 
        colorbar;%caxis([-4 0]);
        title([num2str(II),' - ',num2str(count)],'FontSize',32)
    %     text(10,10,num2str(peak_rel),'Color','w','FontSize',32);
        text(10,3,num2str(peak),'Color','w','FontSize',32);
        drawnow;
        if peak>20e3
            if indtint>1
                indtint = indtint-1;
            end
            disp('Exposure too high!')
        elseif peak<600
            if indtint<numtint
                indtint = indtint+1;
            end
            disp('Exposure too low!')
        else
            peak_mat(II,count) = peak/tint;
            count = count+1;
        end
        figure(204)
        imagesc(rot_arrQWP2,rot_arrLP2,log10(peak_mat/ma_peak))
        axis image;
        xlabel('Rot QWP2 [deg]')
        ylabel('Rot LP2 [deg]')
        colorbar
        drawnow
        if count>numRot; break; end
    end
end
%% find min and accept result
ma = max(peak_mat(:));
peak_norm_mat = peak_mat/ma_peak;
[mi,ind_mi] = min(peak_mat(:)/ma_peak);
disp(['Min extinction ratio: ', num2str(mi)])
[ind_x,ind_y] = ind2sub(size(peak_mat),ind_mi);
disp(['LP2 rot: ', num2str(rot_arrLP2(ind_x)),' QWP2 rot: ', num2str(rot_arrQWP2(ind_y))])

% Accept min result (or chose one)
% rotLP2_min = 197.8; 
% rotQWP2_min = 98.88;
rotLP2_min = rot_arrLP2(ind_x);
rotQWP2_min = rot_arrQWP2(ind_y);
hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,rotLP2_min,rotQWP2_min]);

%% Accept final result
% bench.LPQWP.posLP1 = bench.LPQWP.axLP1.reqPosAct();
bench.LPQWP.posQWP1 = rotQWP1_minStd2;
bench.LPQWP.posLP2 = rotLP2_min;
bench.LPQWP.posQWP2 = rotQWP2_min;
disp(['Min extinction ratio: ', num2str(peak/ma_peak)])
disp(['LP1 rot: ', num2str(bench.LPQWP.posLP1)])
disp(['QWP1 rot: ', num2str(bench.LPQWP.posQWP1)])
disp(['LP2 rot: ', num2str(bench.LPQWP.posLP2)])
disp(['QWP2 rot: ', num2str(bench.LPQWP.posQWP2)])
% hcst_LPQWP_move(bench,[nan,rotQWP1_minStd2,rotLP2_min,rotQWP2_min]);
hcst_LPQWP_move(bench,[nan,bench.LPQWP.posQWP1,bench.LPQWP.posLP2,bench.LPQWP.posQWP2]);


%% Check polarization contrast, i.e. the ratio between going thru the empty slot and going thru the VVC

tint_arr2 = [5e-5, 1e-4, 5e-4, 1e-3, 2.5e-3, 5e-3, 1e-2,1e-1, 5e-1, 1., 2.5, 5, 10, 20, 30];
numtint = numel(tint_arr2);

% filter position
hcst_FW_setPos(bench,1);% Focus viewing mode

hcst_LPQWP_move(bench,[nan,bench.LPQWP.posQWP1,bench.LPQWP.posLP2,bench.LPQWP.posQWP2]);

% Go through the Zernike mask
hcst_FPM_move(bench,[bench.FPM.empty_slot_V , bench.FPM.empty_slot_H, nan]);

tint = 1e-1;
hcst_andor_setExposureTime(bench,tint);
im0 = hcst_andor_getImage(bench); %- dark0;
peak_crossed = max(im0(:))/tint;
disp(['Max: ',num2str(max(im0(:)))])

figure(303)
imagesc(im0)
axis image
colorbar;




% filter position
hcst_FW_setPos(bench,4);% Focus viewing mode
NDfilter_cal = 21.2938 * 4.4506;

% Move to VVC mask
hcst_FPM_move(bench,[bench.FPM.offaxis_VVC_V, bench.FPM.offaxis_VVC_H, nan]);
indtint = 6;
while 1
    tint = tint_arr2(indtint);
    hcst_andor_setExposureTime(bench,tint);

    im0 = hcst_andor_getImage(bench); %- dark0;

    peak = max(im0(:));

    figure(112);
    imagesc(log10_4plot(im0/2^16));
    axis image; 
    colorbar;%caxis([-4 0]);
%     title([num2str(count)],'FontSize',32)
    text(10,3,num2str(peak),'Color','w','FontSize',32);
    drawnow;
    if peak>20e3
        if indtint>1
            indtint = indtint-1;
        else
            break
        end
        disp('Exposure too high!')
    elseif peak<600
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
%%
hcst_LPQWP_move(bench,[bench.LPQWP.posLP1,bench.LPQWP.posQWP1,bench.LPQWP.posLP2,bench.LPQWP.posQWP2]);
disp('Done moving LP/QWPs')
