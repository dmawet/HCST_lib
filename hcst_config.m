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
%   
%
%
%   Arguments/Outputs:
%   bench = hcst_config()
%       'bench' is an instance of the Bench class that is a drop-in
%          replacement for the bench struct that is passed by reference.
%           It contains all pertinent bench information and instances of
%           control objects.
%          
%
%
%   Examples:
%       bench = hcst_config()
%           Creates and returns the core 'bench' struct 
%


%% Add the path to our libraries

% addpath(genpath('/home/hcst/HCST_lib/'));
addpath('/home/hcst/HCST_lib/Andor/');
addpath('/home/hcst/HCST_lib/DM/');
addpath('/home/hcst/HCST_lib/DM/utils/');
addpath('/home/hcst/HCST_lib/FPM/');
addpath('/home/hcst/HCST_lib/FW/');
addpath(genpath('/home/hcst/HCST_lib/LS/'));
addpath(genpath('/home/hcst/HCST_lib/TTM/'));


%% Create the FPM substruct

% NOTE: all zaber positions are in [mm]

% Default position for the FPM axes
% If an axis has not been homed prior to call to hcst_setUpFPM, that axis
%   will be moved to this position
FPM.User_V0 = 1.5;
FPM.User_H0 = 7.304999;
FPM.User_F0 = 5.000099;

% Upper bounds for the motion in each axis
FPM.VBOUND = 26.5;
FPM.HBOUND = 8;   %DO NOT CHANGE UNLESS YOU'RE SURE THERE ARE NO COLLISIONS
FPM.FBOUND = 26.5;

% Axes positions for the center of the Vortex
% FPM.VORTEX_V0 = 1.5;
% FPM.VORTEX_H0 = 7.304999;
% FPM.VORTEX_F0 = 5.000099;
% Updated by G. Ruane 2018jun01
% FPM.VORTEX_V0 = 1.833;
% FPM.VORTEX_H0 = 5.684;
% FPM.VORTEX_F0 = 3.955;
% Updated by G. Ruane 2018aug22
% FPM.VORTEX_V0 = 1.914;
% FPM.VORTEX_H0 = 5.705;
% FPM.VORTEX_F0 = 3.955;
% Updated by G. Ruane 2018oct26 (after removing analyzer)
% FPM.VORTEX_V0 = 1.8960;
% FPM.VORTEX_H0 = 5.7050;
% FPM.VORTEX_F0 = 3.9550;
% Updated by G. Ruane 2018nov9 after putting in polarizers 
% FPM.VORTEX_V0 = 1.8683;
% FPM.VORTEX_H0 = 5.7457;
% FPM.VORTEX_F0 = 3.9550;
% Updated by G. Ruane 2018nov19
% FPM.VORTEX_V0 = 1.855;
% FPM.VORTEX_H0 = 5.745;
% FPM.VORTEX_F0 = 6;
% Updated by J. Llop 2018Dec03/2019Jan08
% FPM.VORTEX_V0 = 2.4230;
% FPM.VORTEX_H0 = 5.6585;
% FPM.VORTEX_F0 = 1.5315;
% Updated by J. Llop 2019Jan10 after changing pinhole
FPM.VORTEX_V0 = 1.8022;
FPM.VORTEX_H0 = 6.1485;
FPM.VORTEX_F0 = 2.2565;


FPM.vortexCharge = 8;

% Axes positions for the center of the Zernike mask 
FPM.ZERNIKE_F0 = 2.2;
FPM.ZERNIKE_V0 = 23.409;
FPM.ZERNIKE_H0 = 5.17;

FPM.CONNECTED = false;

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
% LS.CENTER_V0 = 8.8;
% LS.CENTER_H0 = 45;
% Updated by G. Ruane 2018may29
% LS.CENTER_V0 = 8.48;
% LS.CENTER_H0  = 45.89;
% Updated by G. Ruane 2018aug22
% bench.LS.CENTER_V0 = 8.15;
% bench.LS.CENTER_H0 = 45.87;
% Updated by G. Ruane 2018nov09
% LS.CENTER_V0 = 8.0600;
% LS.CENTER_H0 = 45.9600;
% Updated by J. Llop 2018Dec03
LS.CENTER_V0 = 13.7500;
LS.CENTER_H0 = 22.1000;

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
DM.NactAcross = 34;
DM.NactAcrossBeam = 25;
DM.centerActBeam = 526;

DM.angDM = 181;
DM.xc = 15;   % x-center of DM in actuator widths
DM.yc = 18;   % y-center of DM in actuator widths
%% Create Andor Neo sub-struct

andor.CONNECTED = false;

% Default exposure time 
andor.default_tint = 0.001;
andor.numCoadds = 1;


% Default pixel encoding index 
% Options:
% int32(0): 'Mono12'
% int32(1): 'Mono12Packed'
% int32(2): 'Mono16'
% int32(3): 'Mono32'
andor.default_pixelEncodingIndex = int32(2);% Set to 16 bit

% current (row,col) of the PSF center 
% andor.FocusCol = 1260;
% andor.FocusRow = 989;
andor.FocusCol = 1738;
andor.FocusRow = 714;

%% Filter wheel 

FW.CONNECTED = false;
FW.defaultPos = 1;

%% Calibrations

% andor.pixelPerLamOverD = 5.75;
% andor.numPixperCycle = 5.75;

info.lambda0 = 775e-9;

% andor.pixelPerLamOverD = 5.75/780e-9*info.lambda0;
% andor.numPixperCycle = 5.75/780e-9*info.lambda0;
andor.pixelPerLamOverD = 6.8/775e-9*info.lambda0;
andor.numPixperCycle = 6.8/775e-9*info.lambda0;


%% Back up and data storage info 

info.HCST_DATA_DIR = '/media/hcst/edc9d85f-b1f5-4499-97aa-197291d84a05/HCST_data/';

% Directory to save back up bench structs
benchBackUpDir = [info.HCST_DATA_DIR,'benchstructs/'];
if(~exist(benchBackUpDir, 'dir'))
    mkdir(benchBackUpDir);
end

info.benchBackUpDir = benchBackUpDir;

info.path2darks = [info.HCST_DATA_DIR,'darks/2019Jan09/'];

%% Create bench object

bench = Bench(FPM, LS, TTM, DM, andor, FW, info );


end
