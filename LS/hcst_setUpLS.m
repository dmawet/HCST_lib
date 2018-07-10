function bench = hcst_setUpLS(bench)
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
%   bench = hcst_setUpLS(bench) Instantiates the Zaber control classes.
%       Updates the LS sub-struct which contains pertient information about
%       the stages as well as the instances of the Zaber BinaryDevice class
%       'bench' is the struct containing all pertient bench information and
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

%% Axes Serial Numbers
% Change these values if the serial numbers on the axes are changed
HOR_AXIS_SN = 47799;    % Horizontal axis
VER_AXIS_SN = 47683;    % Vertical axis

%%  Prepare MATLAB serial port
% Instantiate the serial object
port = serial('/dev/ttyZabers');

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
    if length(devs) ~= 2
        error('%d axes were detected; 2 were expected', length(devs))
    end
    
    % Use device serial numbers to match axes
    for i = 1:2
        serNum = devs(i).request(63,1).Data;
        if serNum == VER_AXIS_SN
            axVer = devs(i);
        elseif serNum == HOR_AXIS_SN
            axHor = devs(i);
        else
            error('An unrecognized zaber was found\n  Serial Numer: %d',...
                serNum)
        end
    end

%% Check if the axes have been homed (have a valid reference point)
    % Read the device mode, convert to binary, determine home status
    devMode = dec2bin(axHor.get(40),16);    % Device mode in binary
    horIsReady = logical(devMode(end-7));   % Read bit_7 (home status)
    devMode = dec2bin(axVer.get(40),16);    % Device mode in binary
    verIsReady = logical(devMode(end-7));   % Read bit_7 (home status)
    
%% Home the axes if they have not been homed
    if ~verIsReady
        axVer.home
        axVer.moveAbs(axVer.Units.positiontonative(bench.LS.User_V0))
    end
    if ~horIsReady
        axHor.home
        axHor.moveAbs(axHor.Units.positiontonative(bench.LS.User_H0))
    end
    
catch exception
    % Close port if an error occurs, otherwise it remains locked
    fclose(port);
    rethrow(exception);
end

if ~isempty(axHor.getposition()) && ~isempty(axVer.getposition())
    bench.LS.CONNECTED = true;
end

%% Populate struct
bench.LS.axV = axVer;
bench.LS.axH = axHor;


end

