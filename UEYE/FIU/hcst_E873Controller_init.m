%% Comments:
% This script initializes the controller and each stage connected to it.
% This should be run first after each power cycle.  The controller object
% can be spawned by the other scripts as well, so it's not necessary to run
% this for random moves.
% 
% Control flow:
%   1.  Load PI GCS2 MATLAB driver
%   2.  Connect to the controller
%   3.  Show connected stages

function hcst_E873Controller_init(bench)

%% Load PI MATLAB Driver GCS2
%  (if not already loaded)
addpath('/home/hcst/HCST_lib/TTM/extern_PIGCS2');

if (~isfield(bench.FIUstages,'stage') || ...
        ~isfield(bench.FIUstages.stage, 'Controller') || ...
        ~isa(bench.FIUstages.stage.Controller, 'PI_GCS_Controller'))
    bench.FIUstages.stage.Controller = PI_GCS_Controller();
end

%% Start connection
%(if not already connected)

% Check if PIdevice is connected
boolPIdeviceConnected = false; 
if (isfield(bench.FIUstages.stage, 'PIdevice'))
    if (bench.FIUstages.stage.PIdevice.IsConnected), ...
            boolPIdeviceConnected = true; 
    end 
end

if (~(boolPIdeviceConnected))
    % TCP/IP
    bench.FIUstages.IP_ADDRESS = '192.168.1.5';
    port = 50000; % 50000 for almost all PI controllers
    bench.FIUstages.stage.PIdevice = ... 
        bench.FIUstages.stage.Controller.ConnectTCPIP ...
        (bench.FIUstages.IP_ADDRESS, port);
end

% Initialize PIdevice object
bench.FIUstages.stage.PIdevice = bench.FIUstages.stage.PIdevice.InitializeController();

%% Activate axes
%Query controller axes
availableAxes = bench.FIUstages.stage.PIdevice.qSAI_ALL; 

% Show for all axes: which stage is connected to which axis
for idx = 1:length(availableAxes)
    % qCST gets the name of the stage
    stageName = bench.FIUstages.stage.PIdevice.qCST(char(availableAxes(idx)));
    disp(['Axis ', availableAxes(idx), ': ', stageName]);
end

availableAxes = char(availableAxes); %Making this a char array here is much nicer to deal with...

%% Populate struct
% NOTE: Controller and PIdevice are already added above
bench.FIUstages.stage.axes = availableAxes;

% Save backup bench object
hcst_backUpBench(bench)

bench.FIUstages.CONNECTED = true;

clear boolPIdeviceConnected port 

end