function hcst_setUpAnalyzerzaberv2(bench)
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

disp('*** Setting up Analyzer Zaber stage... ***');
% import zaber.motion.binary.*;
% import zaber.motion.*;
import zaber.motion.ascii.*;
import zaber.motion.*;
try
%     conn = Connection.openSerialPort('/dev/ttyFEUzaber');
    conn = Connection.openSerialPort('/dev/ttyAnalyzerZaber');

    devices = conn.detectDevices();
    device = devices(1);
        
    fprintf('Device %d has device ID %d.\n', device.getDeviceAddress(), device.getIdentity().getDeviceId());
%%
     % home all axes of device
%     device.getAllAxes().home();

    axis = device.getAxis(1);

    % Move axis 1 to 1cm
%     axis.moveAbsolute(1, Units.LENGTH_CENTIMETRES);    
catch exception
    disp(getReport(exception));
end

bench.Analyzerzaber.conn = conn;
bench.Analyzerzaber.axis = axis;

bench.Analyzerzaber.CONNECTED = true;
% 
disp('*** Zaber stages for Analyzer Zaber initialized. ***');
% 

% % Save backup bench object
% hcst_backUpBench(bench)
end

