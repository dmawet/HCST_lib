function hcst_setUpBS(bench)
%hcst_setUpLS Function to prepare the LS for control
%   
%   - This function should be called before calling any other LS functions
%   - It uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   - It creates two instances of the class, one for each axis
%   - It does not home the Zabers unless needed. If needed, it returns them
%       to the position specified by bench.LS.User_#0 where #={V, H}
%   - It uses the serial numbers of the zabers to match the axes correctly
%   
%
%   Arguments/Outputs:
%   hcst_setUpLS(bench) Instantiates the Zaber control classes.
%       Updates the LS sub-struct which contains pertinent information about
%       the stages as well as the instances of the Zaber BinaryDevice class
%       'bench' is the object containing all pertinent bench information and
%           instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpFPM(bench)
%           Instantiates the Zaber control classes. Then updates 'bench', 
%           the LS sub-struct, and the requisite classes 
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpLS
%

disp('*** Setting up BS stage... ***');

%% Axes Serial Numbers
% Change these values if the serial numbers on the axes are changed
BS_AXIS_SN = 60705;    % Vertical axis

%%  Prepare MATLAB serial port
% Instantiate the serial object
port = serial('/dev/ttyBSZaber');

% Set default serial port properties for the binary protocol.
set(port, ...
    'BaudRate',     9600, ...
    'DataBits',     8, ...
    'FlowControl',  'none', ...
    'Parity',       'none', ...
    'StopBits',     1, ...
    'Timeout',      0.5);

% Disable timeout warning; Zaber lib intentionally times out for some reads
warning off MATLAB:serial:fread:unsuccessfulRead

% Open the port.
fopen(port);

%% Instantiate the Zaber Classes
try
    % Create BinaryProtocol object (only 1 since axes are daisy-chained)
    protocol = Zaber.BinaryProtocol(port);
    
    %__finddevices is used (instead of direct BinaryDevice instantiation)
    %   to prevent errors from axes getting re-numbered
    
    % Find all devices within chain
    devs = protocol.finddevices();
    % Check that both (and no more) were registered
    if length(devs) ~= 1
        error('%d axes were detected; 1 were expected', length(devs))
    end
    
    % Use device serial numbers to match axes
    for i = 1:1
        serNum = devs(i).request(63,1).Data;
        if serNum == BS_AXIS_SN
            axBS = devs(i);
        else
            error('An unrecognized zaber was found\n  Serial Numer: %d',...
                serNum)
        end
    end

%% Check if the axes have been homed (have a valid reference point)
    % Read the device mode, convert to binary, determine home status
    devMode = dec2bin(axBS.get(40),16);    % Device mode in binary
    BSIsReady = logical(devMode(end-7));   % Read bit_7 (home status)
    
%% Home the axes if they have not been homed
    if ~BSIsReady
        axBS.home
        axBS.moveAbs(axBS.Units.positiontonative(bench.BS.User_H0))
    end
    
catch exception
    % Close port if an error occurs, otherwise it remains locked
    fclose(port);
    rethrow(exception);
end

if ~isempty(axBS.getposition())
    bench.BS.CONNECTED = true;
end

disp('*** Zaber stages for BS initialized. ***');


%% Populate struct
bench.BS.ax = axBS;

% Save backup bench object
hcst_backUpBench(bench)
end

