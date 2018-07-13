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
%   
%   - TODO (in no particular order):
%       Create/read conf file
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
%       hcst_config()
%           Creates and returns the core 'bench' struct 
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench
%


%% Add the path to our libraries

addpath(genpath('/home/hcst/HCST_lib'));

%% Create the FPM substruct

% NOTE: all zaber positions are in [mm]

% Default position for the FPM axes
% If an axis has not been homed prior to call to hcst_setUpFPM, that axis
%   will be moved to this position
FPM.User_V0 = 1.5;
FPM.User_H0 = 7.304999;
FPM.User_F0 = 5.000099;

% Upper bounds for the motion in each axis
FPM.VBOUND = 27;
FPM.HBOUND = 8;   %DO NOT CHANGE UNLESS YOU'RE SURE THERE ARE NO COLLISIONS
FPM.FBOUND = 27;

% Axes positions for the center of the Vortex
% FPM.VORTEX_V0 = 1.5;
% FPM.VORTEX_H0 = 7.304999;
% FPM.VORTEX_F0 = 5.000099;
% Updated by G. Ruane 2018jun01
FPM.VORTEX_V0 = 1.833;
FPM.VORTEX_H0 = 5.684;
FPM.VORTEX_F0 = 3.955;

% Axes positions for the center of the Zernike mask 
FPM.ZERNIKE_V0 = 1.5;
FPM.ZERNIKE_H0 = 7.304999;
FPM.ZERNIKE_F0 = 5.000099;

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
LS.CENTER_V0 = 8.48;
LS.CENTER_H0  = 45.89;

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
DM.offsetAct = [2 -3];% number of actuators between the 
                      % beam center and the center of the DM [x,y]
                      % center actuator is assumed to be #459
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


%% Calibrations

andor.pixelPerLamOverD = 6;
andor.numPixperCycle = 5.86;

bench = Bench(FPM, LS, TTM, DM, andor);
end
