function hcst_setUpLPQWP(bench)
%hcst_setUpFPM Function to prepare the FPM for control
%   
%   - This function should be called before calling any other FPM functions
%   - It uses the Conex.py class
%   - It creates three instances of the class, one for each axis
%   - It does not home the Conexs unless needed. If needed, it returns them
%       to the position specified by bench.LPQWP.User_#0 where #={V, H, or F}
%   
%
%   Arguments/Outputs:
%   hcst_setUpFPM(bench) Instantiates the Conex control classes.
%       Updates the FPM sub-struct which contains pertient information 
%       about the stages as well as the instances of the Conex.py class. 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpFPM(bench)
%           Updates 'bench', the FPM sub-struct, and the requisite classes
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

disp('*** Setting up LPQWP stages... ***');

%% Add the directory with all our libraries to the Python search path
HCST_lib_PATH = '/home/hcst/HCST_lib/LPQWP';
% HCST_lib_PATH = '/home/hcst/HCST_lib/FPM';
if count(py.sys.path, HCST_lib_PATH) == 0
    insert(py.sys.path, int32(0), HCST_lib_PATH);
end

%% Instantiate the three axes
% axLP2 = py.ConexRot.Conex_Device('/dev/ttyUSB12', 921600);
% axQWP2 = py.ConexRot.Conex_Device('/dev/ttyUSB8', 921600);
% axLP1 = py.ConexRot.Conex_Device('/dev/ttyUSB9', 921600);
% axQWP1 = py.ConexRot.Conex_Device('/dev/ttyUSB0', 921600);
axLP2 = py.ConexRot.Conex_Device('/dev/ttyLP2', 921600);
axQWP2 = py.ConexRot.Conex_Device('/dev/ttyQWP2', 921600);
axLP1 = py.ConexRot.Conex_Device('/dev/ttyLP1', 921600);
axQWP1 = py.ConexRot.Conex_Device('/dev/ttyQWP1', 921600);

%% Open the three axes for comms
axLP1.open()
axQWP1.open()
axLP2.open()
axQWP2.open()

%% Check if the axes are ready to be moved
axLP1IsReady = axLP1.isReady();
axQWP1IsReady = axQWP1.isReady();
axLP2IsReady = axLP2.isReady();
axQWP2IsReady = axQWP2.isReady();

%% Home the axes if they are not ready to be moved

%Home the horizontal axis first to prevent collisions
% if ~axLPIsReady
%     horIsReady = axLP.home(true);    %Use blocking (true) to ensure home before move
%     if horIsReady
%         axLP.moveAbs(bench.LPQWP.User_H0,true)    %blocking to ensure pos reached
%     else
%         warning("LP axis reported not ready after moving");
%     end
% end
% if ~axQWPIsReady
%     verIsReady = axQWP.home(true);    %Use blocking (true) to ensure home before move
%     if verIsReady
%         axQWP.moveAbs(bench.LPQWP.User_V0,true)    %blocking to ensure pos reached
%     else
%         warning("Vertical axis reported not ready after moving");
%     end
% end


% reqPosSet() returns -9999 on error, so if there's no error, we're good.
if (axLP1.reqPosSet() ~= -9999) && (axQWP1.reqPosSet() ~= -9999) 
    bench.LPQWP.CONNECTED = true;
end

disp('*** LPQWP stages initialized. ***');

%% Populate struct
bench.LPQWP.axLP1 = axLP1;
bench.LPQWP.axQWP1 = axQWP1;
bench.LPQWP.axLP2 = axLP2;
bench.LPQWP.axQWP2 = axQWP2;

% Save backup bench object
hcst_backUpBench(bench)

%% To HOME
% bench.LPQWP.axLP1.home(true)
% bench.LPQWP.axQWP1.home(true)
% bench.LPQWP.axLP2.home(true)
% bench.LPQWP.axQWP2.home(true)

end

