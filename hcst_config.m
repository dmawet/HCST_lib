function bench = hcst_config()
%hcst_config Function to instantiate core variables for bench
%   
%   - This function should be called before any other hcst_ functions
%   - It creates a struct that gets passed to all hcst_[...] functions 
%       which operate on elements of the bench
%   - It creates the following sub-structs on the bench:
%        1) FPM
%        2) LS
%        3) TTM
%        4) DM
%        5) andor
%        6) FW
%        7) NKT
%        8) FIUStages
%        9) BS
%        10) Femto
%   
%   Arguments/Outputs:
%   bench = hcst_config()
%       'bench' is an instance of the Bench class that is a drop-in
%          replacement for the bench struct that is passed by reference.
%           It contains all pertinent bench information and instances of
%           control objects.
%          


%% Add the path to our libraries

addpath('/home/hcst/HCST_lib/');
addpath('/home/hcst/HCST_lib/Andor/');
addpath('/home/hcst/HCST_lib/DM/');
addpath('/home/hcst/HCST_lib/DM/utils/');
addpath('/home/hcst/HCST_lib/FPM/');
addpath('/home/hcst/HCST_lib/FW/');
addpath('/home/hcst/HCST_lib/LPQWP/');
addpath('/home/hcst/HCST_lib/BS/');
addpath('/home/hcst/HCST_lib/Analyzer/');
addpath('/home/hcst/HCST_lib/FEUzaber/');
addpath('/home/hcst/HCST_lib/cameraZaber/');
addpath('/home/hcst/HCST_lib/FIU/');
addpath('/home/hcst/HCST_lib/FS/');
addpath('/home/hcst/NKT/');
addpath(genpath('/home/hcst/HCST_lib/LS/'));
addpath(genpath('/home/hcst/HCST_lib/TTM/'));
addpath('/home/hcst/HCST_lib/Femto/');
addpath('/home/hcst/HCST_lib/CAMZ/pyKDC101/src/pyKDC101/');


%% Create the FPM substruct

% NOTE: all zaber positions are in [mm]

% Default position for the FPM axes
% If an axis has not been homed prior to call to hcst_setUpFPM, that axis
%   will be moved to this position
FPM.User_V0 = 1;
FPM.User_H0 = 1;
FPM.User_F0 = 5.000099;

% Upper bounds for the motion in each axis
FPM.VBOUND = 26.5;
FPM.HBOUND_lower = 3;   %DO NOT CHANGE UNLESS YOU'RE SURE THERE ARE NO COLLISIONS
FPM.HBOUND_upper = 26.5;  
FPM.FBOUND = 26.5;

%LOWER BOUND for FPM.FBOUND = 1.0;

% Axes positions for the center of the Vortex
% FPM.VORTEX_V0 = 3.1923; %3.1628;
FPM.VORTEX_V0 = 1.8400; %2.0325; %2.2906; %0.8506;
FPM.VORTEX_H0 = 5.5550; %7.0433; %8.6383; %10.1163;
FPM.VORTEX_F0 = 4.; %14.; %16.6000; %

% Apr 2022 - before switching to LC
FPM.LC_V0 = 5.9903;
FPM.LC_H0 = 8.6183;
FPM.LC_F0 = 13.7000;
% Lyot Coronagraph FPM

FPM.LC_100um_1_V0 = 5.9783;
FPM.LC_100um_1_H0 = 5.3926;
FPM.LC_100um_1_F0 = 1.3;

FPM.LC_100um_2_V0 = 5.9861;
FPM.LC_100um_2_H0 = 3.3864;
FPM.LC_100um_2_F0 = 1.2;

FPM.LC_100um_3_V0 = 5.9713;
FPM.LC_100um_3_H0 = 7.3801;
FPM.LC_100um_3_F0 = 1.2;

FPM.LC_80um_1_V0 = 4.2512;
FPM.LC_80um_1_H0 = 4.3876;
FPM.LC_80um_1_F0 = 1.2;

FPM.LC_80um_2_V0 = 4.2384;
FPM.LC_80um_2_H0 = 6.3926;
FPM.LC_80um_2_F0 = 1.3;

FPM.LC_60um_1_V0 = 2.5215;
FPM.LC_60um_1_H0 = 5.3838;
FPM.LC_60um_1_F0 = 1.3;

FPM.LC_60um_2_V0 = 2.5312;
FPM.LC_60um_2_H0 = 3.3826;
FPM.LC_60um_2_F0 = 1.3;

FPM.LC_60um_3_V0 = 2.5215;
FPM.LC_60um_3_H0 = 7.3776;
FPM.LC_60um_3_F0 = 1.3;

% FPM.LC_100um_1a_V0 = 5.9608;
% FPM.LC_100um_1a_H0 = 5.4426;
% FPM.LC_100um_1a_F0 = 1.8;
% FPM.LC_100um_1b_V0 = 5.9758;
% FPM.LC_100um_1b_H0 = 5.3526;
% FPM.LC_100um_1b_F0 = 0.8;
% FPM.LC_100um_1c_V0 = 5.9758;
% FPM.LC_100um_1c_H0 = 5.3281;
% FPM.LC_100um_1c_F0 = 0.5;


FPM.vortexCharge = -8;

FPM.SVC_V0 = 22.2040;
FPM.SVC_H0 = 7.2035;
FPM.SVC_F0 = 3.4000;

% for Niyati 2024 Jun 04
FPM.SVC_V0 = 23.8260; % with dimple
FPM.SVC_H0 = 6.0840;
FPM.SVC_F0 = 12.;
FPM.SVC_V1 = 1.6660; % without dimple
FPM.SVC_H1 = 6.1380;
FPM.SVC_F1 = 7.;

% Found Jan29, 2021:
%           SVC_V0: 22.7350
%           SVC_H0: 6.9330
%           SVC_F0: 1

% Axes positions for the center of the Zernike mask 
FPM.ZERNIKE_F0 = 1.8555;
FPM.ZERNIKE_V0 = 22;
FPM.ZERNIKE_H0 = 3.3725;

% empty slot, or thru the DVC to cross polarization
FPM.empty_slot_V = 22;
FPM.empty_slot_H = 10.1918; %7
FPM.empty_slot_F = 4;
FPM.offaxis_VVC_V = 3;
FPM.offaxis_VVC_H = 4.5;

FPM.CONNECTED = false;
%% Create the LPQWP substruct

% NOTE: all zaber positions are in [mm]

% Default position for the FPM axes
% If an axis has not been homed prior to call to hcst_setUpFPM, that axis
%   will be moved to this position
% LPQWP.User_V0 = 1.5;
% LPQWP.User_H0 = 7.304999;
% LPQWP.User_F0 = 5.000099;

% Upper bounds for the motion in each axis
% LPQWP.VBOUND = 26.5;
% LPQWP.HBOUND = 8;   %DO NOT CHANGE UNLESS YOU'RE SURE THERE ARE NO COLLISIONS
% LPQWP.FBOUND = 26.5;

% Axes positions for the center of the Vortex
% LPQWP.posLP1 = 0;
% LPQWP.posQWP1 = 219.9000; %169.5;%207.7802;
% LPQWP.posLP2 = 174.4158; %236.1193;%41.601;
% LPQWP.posQWP2 = 29.733; %274.0926;%54.9427;
% Aug 4, 2023
% Oct 18, 2023
LPQWP.posLP1 = 300;
LPQWP.posQWP1 = 184.7286; %93.2857; %169.5;%207.7802;
LPQWP.posLP2 = 183.7504; %186.3571; %185.3571; %222.8658; %236.1193;%41.601;
LPQWP.posQWP2 = 199.2933; %195.8; %200.4000; 197.8000; %60.3030; %274.0926;%54.9427;

% bench.LPQWP.posLP2-70, bench.LPQWP.posQWP2-30

LPQWP.CONNECTED = false;

%% Create the LS substruct

% NOTE: all zaber positions are in [mm] (not device units)

% Default position for the LS axes
% If an axis has not been homed prior to call to hcst_setUpLS, that axis
%   will be moved to this position
LS.User_V0 = 8.8;        
LS.User_H0 = 0;           

% Upper bounds for the motion in each axis
LS.VBOUND = 25.4;
LS.HBOUND = 50.8;   

% Axes positions for the center of the LS
% LS.CENTER_V0 = 19.9956;
% LS.CENTER_H0 = 43.2658;   
LS.CENTER_V0 = 25.6456;
LS.CENTER_H0 = 43.6158;   

LS.CONNECTED = false;

%% Create the TTM substruct

% NOTE: all TTM positions are in mrad

% Connection settings
TTM.isTCPIP = true;       %Flag to choose between TCPIP and USB
                                    %NOTE: USB CURRENTLY NOT SUPPORTED
TTM.IP_ADDRESS = 'hcst-ttm.caltech.edu';
                                %NOTE, IP number also accepted
                                %(131.215.193.165)

% Default position for the TTM axes
% If an axis is not in Closed loop control prior to call to hcst_setUpTTM,
%    that axis will be moved to this position
TTM.User_CH1_0 = 5.000;        
TTM.User_CH2_0 = 5.000;            

% Axes positions for the center of range
TTM.CENTER_CH1_0 = 5.000;
TTM.CENTER_CH2_0 = 5.000;

TTM.CONNECTED = false;

%% DM sub-struct

DM.CONNECTED = false;

% Note where the beam is with respect to the DM (need a function to
% determine this later...)
% DM.NactAcross = 34;
DM.NactAcrossBeam = 30;
% DM.centerActBeam = 526;
% 
% DM.angDM = 181;
% DM.xc = 15;   % x-center of DM in actuator widths
% DM.yc = 18;   % y-center of DM in actuator widths

% After removing first plate
DM.angDM = 0;
% DM.xc = 18.3129;   % x-center of DM in actuator widths
% DM.yc = 21.3626;   % y-center of DM in actuator widths
DM.xc = 18.;   % x-center of DM in actuator widths
DM.yc = 18.;   % y-center of DM in actuator widths
%% Create Andor Neo sub-struct

andor.CONNECTED = false;

% Default exposure time 
andor.default_tint = 0.001;
andor.numCoadds = 1;

andor.warnKernLimit=true;

% Default pixel encoding index 
% Options:
% int32(0): 'Mono12'
% int32(1): 'Mono12Packed'
% int32(2): 'Mono16'
% int32(3): 'Mono32'
andor.default_pixelEncodingIndex = int32(2);% Set to 16 bit

% current (row,col) of the PSF center 
% andor.FocusCol = 1.4588e+03;
% andor.FocusRow = 1.2105e+03;
% andor.FocusCol = 1.4575e+03;
% andor.FocusRow = 1.1807e+03;
andor.FocusCol = 1.6325e+03;
andor.FocusRow = 1.2972e+03;

andor.PupCol = 1078;
andor.PupRow = 1302;

andor.FEURow = 768;
andor.FEUCol = 1293;

% For the Super Nyquist experiments with the DM satellite spot
andor.superNy_col = 1836;
andor.superNy_row =  574;

%% Filter wheel 

FW.CONNECTED = false;
FW.defaultPos = 1;

% ND filters characterized and saved here:
FW.ND_exct_arr = [4233.9,2967.84,2173.9];
FW.ND_wave_arr = [685,775,814];
%% NKT 

NKT.CONNECTED = false;
NKT.numTries = 10;
NKT.delay = 1;
NKT.lambda = 780;
info.NKT_lib_PATH = '/home/hcst/NKT/';

%% FIU 
FIUstages.CONNECTED = false; 
% For first channel (SMF to the powermeter (Femto)):
FIUstages.CENTER_V0 = 9.1995;
FIUstages.CENTER_H0 = 0.0255;
FIUstages.CENTER_F0 = -1.1795;
% For second channel (SMF to camera):
FIUstages.CENTER2_V0 = 3.8390;
FIUstages.CENTER2_H0 = -0.2372;
FIUstages.CENTER2_F0 = -2.2300;
FIUstages.favoriteAngSep2FIUpos_6 = [8.3400   90.25    0.0114]; %[Ang Sep, rot for DM speckle,H pos for FIU stage]
FIUstages.favoriteAngSep2FIUpos_3 = [4.8150   90.75    0.0007];
FIUstages.amplitudeCal_slope = 0.4596;
% FIUstages.smf_pos_efc1 = [0.0466   -1.1810    9.2018];
% FIUstages.smf_pos_efc1 = [-9.1412   -4.1035    9.2422]; % With SMF on the
% left
FIUstages.smf_pos_efc1 =  [-0.2351   -2.2350    3.8658];
FIUstages.smf_pos_efc1 =  [ -0.2386   -2.2350    3.8668]; %Oct 18, 2023
% FIUstages.smf_angular_pos_efc1=[5.8500,-0.1];% With SMF on the
% left
FIUstages.smf_angular_pos_efc1=[0,-8]; % in lambda Over D
% FIUstages.gaussianFWHM = 8.0176; % For old position of FEU (at an angle).
% How did I compute this??

% For the Super Nyquist experiments with the DM satellite spot
FIUstages.CENTER_superNy_V0 = 9.4338;
FIUstages.CENTER_superNy_H0 = -9.1670;
FIUstages.CENTER_superNy_F0 = -4.1150;
FIUstages.smf_pos_sn_superNy = [-9.2170 -4.1150 9.4333];
% diff in V between speckle and PSF center: CENTER2_H0-smf_pos_efc1(3) = -0.0240
FIUstages.gaussianFWHM = 5.14;
%% Beam splitter
BSzaber.User_H0 = 0;
BSzaber.CONNECTED = false;
BSzaber.BOUND = 25.4;
BSzaber.posOut =  0;
BSzaber.posIn =  2.6;
BSzaber.dFocusCol = 1.7662e+03-1.8695e+03;
BSzaber.dFocusRow = 658-789.2500;

%% Analyzer Zaber
Analyzerzaber.User_H0 = 0;
Analyzerzaber.CONNECTED = false;
Analyzerzaber.BOUND = 5.001;
Analyzerzaber.posOut =  1.5;
Analyzerzaber.posIn =  5.4;
Analyzerzaber.curr_pos =  [];
%% FEU Zaber
FEUzaber.User_H0 = 0;
FEUzaber.CONNECTED = false;
FEUzaber.BOUND = 25.4;
FEUzaber.posOut =  1.7;
FEUzaber.posIn =  0.4;

%% cameraZaber
cameraZaber.User_H0 = 0;
cameraZaber.CONNECTED = false;
cameraZaber.BOUND = 25.4;
cameraZaber.z0 =  7.9088;
cameraZaber.z_foc1 = 7.0571;
cameraZaber.z_foc2 = 10.0571;
cameraZaber.z_foc3 = 6.5571;
cameraZaber.z_foc4 = 10.5571;
cameraZaber.z_pup0 =  8.2500;
cameraZaber.z_pup1 = 7.0571;
cameraZaber.z_pup2 = 10.0571;
cameraZaber.z_pup3 = 6.5571;
cameraZaber.z_pup4 = 10.5571;
cameraZaber.posZ1_pup_col = 629.4592;
cameraZaber.posZ1_pup_row = 1.2599e+03;
cameraZaber.posZ2_pup_col = 935.7973;
cameraZaber.posZ2_pup_row = 1.2287e+03;
cameraZaber.posZ3_pup_col = 581.9166;
cameraZaber.posZ3_pup_row = 1.2647e+03;
cameraZaber.posZ4_pup_col = 985.6697;
cameraZaber.posZ4_pup_row = 1.2201e+03;
cameraZaber.z1_foc_tint = 0.1;
cameraZaber.z2_foc_tint = 0.1;
cameraZaber.z3_foc_tint = 0.1;
cameraZaber.z4_foc_tint = 0.1;
cameraZaber.dispRateXvsZ = -59.8301;
%% Femto and Labjack
Femto.CONNECTED = false;
Femto.V = 0;
Femto.waitTimeAfterGainChange = 1;
Femto.gainStep = 9.97;
Femto.averageNumReads=10;
Femto.min_averageNumReads=1000;
Femto.noise_arr = [...
9.3197e-05,... 
7.8209e-05,... 
9.3952e-05,... 
0.00011156,... 
0.00028216,... 
0.00084583,... 
0.0029408];
Femto.V_offset = [...
0.013724,...
0.014117,...
0.014253,...
0.014272,...
0.013659,...
0.0041316,...
-0.089539];

%% Create the FS substruct

% NOTE: all zaber positions are in [mm]

% Default position for the FPM axes
% If an axis has not been homed prior to call to hcst_setUpFPM, that axis
%   will be moved to this position
FS.User_V0 = 1.5;
FS.User_H0 = 7.304999;
FS.User_F0 = 5.000099;

% Upper bounds for the motion in each axis
FS.VBOUND = 26.5;
FS.HBOUND = 26.5;   %DO NOT CHANGE UNLESS YOU'RE SURE THERE ARE NO COLLISIONS
FS.FBOUND = 26.5;

% Axes positions for the center of the FS
% Pos 0 is big circle empty
FS.V0 = 7.25;
FS.H0 = 5.8500;
FS.F0 = 14;
% Pos 1 is 180deg aperture
FS.V1 = 14.89; %25.9415;
FS.H1 = 2.805; %for slot 2; 16.75 for slot 1; %2.6240;
FS.F1 = 14;
% Pos 2 is 60deg aperture
FS.V2 = 19.6125; %22.8565;
FS.H2 = 1.5500; %4.3870;
FS.F2 = 15; %14.9850;

FS.CONNECTED = false;

%% CAMZ struct (scicam focus stage)
CAMZ.serialNumber = '27268827';

%% Calibrations

% andor.pixelPerLamOverD = 5.75;
% andor.numPixperCycle = 5.75;

info.lambda0 = 775e-9;

% andor.pixelPerLamOverD = 4.7/780e-9*info.lambda0;
% andor.numPixperCycle = 4.7/780e-9*info.lambda0;
% andor.pixelPerLamOverD = 4.8111/775e-9*info.lambda0; %AVC
% andor.numPixperCycle = 4.8111/775e-9*info.lambda0;
% andor.pixelPerLamOverD = (4.45+0.075)/775e-9*info.lambda0;
% andor.numPixperCycle = (4.45+0.075)/775e-9*info.lambda0;
% pre Apr28 2021
% andor.pixelPerLamOverD = (5.1377)/775e-9*info.lambda0;
% andor.numPixperCycle = (5.1377)/775e-9*info.lambda0;
% Apr 12, 2022
% andor.pixelPerLamOverD = (5.1818)/775e-9*info.lambda0;
% andor.numPixperCycle = (5.1818)/775e-9*info.lambda0;
% Dec 06
andor.pixelPerLamOverD = (8.7)/775e-9*info.lambda0;
andor.numPixperCycle = (8.7)/775e-9*info.lambda0;

%% UEYE Camera
UEYE.camera_id = 0;
info.UEYE_lib_PATH = '/home/hcst/HCST_lib/UEYE/pypyueye_hcst';


%% Back up and data storage info 

info.HCST_DATA_DIR = '/home/hcst/Documents/backUp/';
% '/media/hcst/edc9d85f-b1f5-4499-97aa-197291d84a05/HCST_data/';
info.OUT_DATA_DIR = [info.HCST_DATA_DIR,'efc_results/'];

% Directory to save back up bench structs
benchBackUpDir = [info.HCST_DATA_DIR,'benchstructs/'];
if(~exist(benchBackUpDir, 'dir'))
    mkdir(benchBackUpDir);
end

info.benchBackUpDir = benchBackUpDir;

info.path2darks = [info.HCST_DATA_DIR,'darks/2024Oct04/'];
info.path2darksND = [info.HCST_DATA_DIR,'darks/2023Jun12/'];%[info.HCST_DATA_DIR,'darksND/2022Mar31/'];

%% Create bench object

bench = Bench(FPM, LPQWP, LS, TTM, DM, andor, FW, NKT, FIUstages, BSzaber,Analyzerzaber,FEUzaber,cameraZaber, Femto,FS, CAMZ, info );


end
