% hcst_rotStagesAutoCrossPol.m
%
%
%
% Jorge Llop - Oct 10, 2019

if(~exist('bench','var'))
	bench = hcst_config();
end

if(~bench.andor.CONNECTED)
	hcst_setUpAndor(bench,false);
end

if(~bench.FPM.CONNECTED)
    hcst_setUpFPM(bench);
end

if(~bench.LPQWP.CONNECTED)
    hcst_setUpLPQWP(bench);
end
%%

tint_arr = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0];
numtint = numel(tint_arr);
indtint = 2;

rotLP1 = 0;
%%
% Go through the Zernike mask
hcst_FPM_move(bench,[24.5 , 3, nan]);

tint = 1e-1;

hcst_andor_setExposureTime(bench,tint);

centrow = bench.andor.FocusRow;
centcol = bench.andor.FocusCol;
cropsize = 512;
hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);

dark0 = 0;

numRot = 24;
% midLP = 143.2;
% midQWP = 79.05;
% delta_ang = 0.25;
% rot_arrLP = linspace(midLP-delta_ang,midLP+delta_ang,numRot);
% rot_arrQWP = linspace(midQWP-delta_ang,midQWP+delta_ang,numRot);
rot_arrLP = linspace(0,339,numRot);
rot_arrQWP = linspace(0,339,numRot);
rot_arrQWP1 = linspace(0,339,numRot);
peak_arr = zeros(numRot,numRot,numRot);
for KK=1:numRot
    rotQWP1 = rot_arrQWP1(KK);
    for II=1:numRot
        rotLP = rot_arrLP(II);
        for JJ=1:numRot
            tint = tint_arr(indtint);
            hcst_andor_setExposureTime(bench,tint);
            
            rotQWP = rot_arrQWP(JJ);
            pos = hcst_LPQWP_move(bench,[rotLP1,rotQWP1,rotLP,rotQWP]);
            im0 = hcst_andor_getImage(bench) - dark0;
            peak = max(im0(:));

            figure(112);
            imagesc(log10_4plot(im0/2^16));
            axis image; 
            colorbar;%caxis([-4 0]);
            title([num2str(KK),' - ',num2str(II),' - ',num2str(JJ)],'FontSize',32)
        %     text(10,10,num2str(peak_rel),'Color','w','FontSize',32);
            text(10,3,num2str(peak),'Color','w','FontSize',32);
            drawnow;
            if peak>60e3
                if indtint<numtint
                    indtint = indtint-1;
                    JJ = JJ -1;
                end
            elseif peak<500
                if indtint>1
                    indtint = indtint+1;
                    JJ = JJ -1;
                end
            else
                peak_arr(KK,II,JJ) = peak/tint;
            end
        end
    end
end
% %% Figure
figure(333)
imagesc(rot_arrQWP,rot_arrLP,peak_arr)
axis image;
xlabel('Rot LP2 [deg]')
ylabel('Rot QWP2 [deg]')
save('/home/hcst/HCST_lib/LPQWP/crossPol_3D.mat','peak_arr')
% % Search min
% [~,ind_mi] = 

%% Search for the best candidates
load('/home/hcst/HCST_lib/LPQWP/crossPol_3D.mat')

centrow = bench.andor.FocusRow;
centcol = bench.andor.FocusCol;
cropsize = 128;
hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);

tint_arr2 = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1.5,2,3,5];
numtint = numel(tint_arr2);

indtint = 1;
peak_mat2 = peak_arr;

for KK=1:numRot
    rotQWP1 = rot_arrQWP1(KK);
    for II=1:numRot
        rotLP = rot_arrLP(II);
        count = 1;
        while 1 
            if peak_arr(KK,II,count) == 0
                disp('Found a zero!')
                tint = tint_arr2(indtint);
                hcst_andor_setExposureTime(bench,tint);

                rotQWP = rot_arrQWP(count);
                pos = hcst_LPQWP_move(bench,[rotLP1,rotQWP1,rotLP,rotQWP]);
                im0 = hcst_andor_getImage(bench) - dark0;
                peak = max(im0(:));

                figure(112);
                imagesc(log10_4plot(im0/2^16));
                axis image; 
                colorbar;%caxis([-4 0]);
                title([num2str(KK),' - ',num2str(II),' - ',num2str(count)],'FontSize',32)
            %     text(10,10,num2str(peak_rel),'Color','w','FontSize',32);
                text(10,3,num2str(peak),'Color','w','FontSize',32);
                drawnow;
                if peak>60e3
                    peak_mat2(KK,II,count) = nan;
                    disp('Wrong type of zero...')
                    count = count+1;
                elseif peak<500
                    if indtint<numtint
                        indtint = indtint+1;
                    end
                    disp('Exposure too low!')
                else
                    peak_mat2(KK,II,count) = peak/tint;
                    count = count+1;
                end
            else
                count = count+1;
            end
            if count>numRot; break; end
        end
    end
end

fitswrite(peak_mat2,'test_peak_mat2.fits')

%% Accept result
rotLP = 143.3;
rotQWP = 79.05;
pos = hcst_LPQWP_move(bench,[rotLP,rotQWP]);
bench.LPQWP.posLP = rotLP;
bench.LPQWP.posQWP = rotQWP;

%%
hcst_disconnectDevices(bench, false, false)
