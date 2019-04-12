function hcst_setUpAndor(bench,wait2stabilize)
%hcst_setUpAndor Set up the HCST Andor Neo Camera
%   - This function should be called before calling any other Andor functions
%   - It uses the atcore.h and libatcore.so 'c' libraries
%   - It sets the camera mode to 'Mono16' (16 bit)
%   - It sets the exposure time to the default
%
%
%   Inputs:
%       hcst_setUpAndor(bench, wait2stabilize)
%       Initializes the Andor Neo libraries
%       Updates the andor sub-struct which contains pertient information
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%       'wait2stabilize' is a logical denoting whether to block execution
%           until after the temperature has stabilized.
%           - True = block/wait;  False = do not block/wait
%
%
%   Examples:
%       hcst_setUpAndor(bench, wait2stab)
%           Updates 'bench' and the andor sub-struct
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%


disp('*** Setting up Andor Neo ... ***');

assert(1 == exist('wait2stabilize','var'), ...
    'MATLAB:narginchk:notEnoughInputs', ...
    'hcst_setUpAndor takes two inputs')

% Default integration time (ms)
default_tint = bench.andor.default_tint;

% Default pixel encoding mode
% 0 for 12-bit and 2 for 16-bit
default_pixelEncodingIndex = bench.andor.default_pixelEncodingIndex;

warning('off','MATLAB:loadlibrary:TypeNotFound')

[notfound,warnings] = loadlibrary('libatcore','atcore.h','alias','lib');
%libfunctionsview lib

% Equivalent of AT_InitialiseLibrary();
err = calllib('lib', 'AT_InitialiseLibrary');
if(err~=0)
    error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_InitialiseLibrary']);
end

% Equivalent of AT_H Handle;
andor_handlePtr = libpointer('int32Ptr',0);

% Equivalent of AT_Open(0, &Handle);
err = calllib('lib', 'AT_Open', 0, andor_handlePtr);
x = get(andor_handlePtr);
andor_handle = x.Value;
bench.andor.andor_handle = andor_handle;

if(err~=0)
    error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Open']);
end

%% Set the pixel encoding to the default setting

try
    hcst_andor_setPixelEncodingIndex(bench,default_pixelEncodingIndex);
catch
    disp('Camera may be off.');
    return;
end

%% Set the exposure time to the default setting

hcst_andor_setExposureTime(bench,default_tint);

%% Get the image formatting parameters (height, width, stride)

hcst_andor_getImageFormatting(bench);

%% Turn off fan

% hcst_andor_toggleFan(bench,'off');
hcst_andor_toggleFan(bench,'off'); %JLlop: Feb 24 while the cooler pump is being repaired

%% Turn on sensor cooler

hcst_andor_setSensorCooling(bench,true,wait2stabilize);


%%

% Initialize to FullFrame size
bench.andor.AOIWidth0 = bench.andor.AOIWidth;
bench.andor.AOIHeight0 = bench.andor.AOIHeight;
bench.andor.centrow0 = bench.andor.AOIHeight0/2+1;
bench.andor.centcol0 = bench.andor.AOIWidth0/2+1;

% Initialize the frame center
bench.andor.centrow = bench.andor.centrow0;
bench.andor.centcol = bench.andor.centcol0;

bench.andor.acquiring = false; % Not currently acquiring frames
bench.andor.continuous = false;% Not currently in continuous mode 

% By default, send warning if signal is above the Kern limit
bench.andor.warnKernLimit = false;

disp('Andor Neo Camera Parameters:');
disp(['     tint = ',num2str(hcst_andor_getExposureTime(bench))]);
disp(['     pixel encoding index = ',num2str(hcst_andor_getPixelEncodingIndex(bench))]);
disp(['     image size (bytes) = ',num2str(hcst_andor_getImageSizeBytes(bench))]);
disp(['     AOIHeight = ',num2str(bench.andor.AOIHeight)]);
disp(['     AOIWidth  = ',num2str(bench.andor.AOIWidth)]);
disp(['     AOIStride = ',num2str(bench.andor.AOIStride)]);
disp('*** Andor Neo Camera Initialized. ***');

bench.andor.CONNECTED = true;

% Save backup bench object
hcst_backUpBench(bench)

end