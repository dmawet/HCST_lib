function hcst_setUpAndor(B,wait2stabilize)
%hcst_setUpAndor Set up the HCST Andor Neo Camera
%   - This function should be called before calling any other Andor functions
%   - It uses the atcore.h and libatcore.so 'c' libraries
%   - It sets the camera mode to 'Mono16' (16 bit)
%   - It sets the exposure time to the default
%
%
%   Inputs:
%       Initializes the Andor Neo libraries
%       Updates the andor sub-struct which contains pertient information
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpAndor(B)
%           Updates 'B.bench' and the andor sub-struct
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFPM
%

assert(1 == exist('wait2stabalize','var'), ...
    'MATLAB:narginchk:notEnoughInputs', ...
    'hcst_setUpAndor takes two inputs')

% Default integration time (ms)
default_tint = B.bench.andor.default_tint;

% Default pixel encoding mode
% 0 for 12-bit and 2 for 16-bit
default_pixelEncodingIndex = B.bench.andor.default_pixelEncodingIndex;

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
B.bench.andor.andor_handle = andor_handle;

if(err~=0)
    error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_Open']);
end

%% Set the pixel encoding to the default setting

try
    hcst_andor_setPixelEncodingIndex(B,default_pixelEncodingIndex);
catch
    disp('Camera may be off.');
    return;
end

%% Set the exposure time to the default setting

hcst_andor_setExposureTime(B,default_tint);

%% Get the image formatting parameters (height, width, stride)

hcst_andor_getImageFormatting(B);

%% Turn off fan

hcst_andor_toggleFan(B,'off');

%%


% Initialize to FullFrame size
B.bench.andor.AOIWidth0 = B.bench.andor.AOIWidth;
B.bench.andor.AOIHeight0 = B.bench.andor.AOIHeight;
B.bench.andor.centrow0 = B.bench.andor.AOIHeight0/2+1;
B.bench.andor.centcol0 = B.bench.andor.AOIWidth0/2+1;
B.bench.andor.centrow = B.bench.andor.centrow0;
B.bench.andor.centcol = B.bench.andor.centcol0;

disp('Andor Neo Camera Initialized:');
disp(['     tint = ',num2str(hcst_andor_getExposureTime(B))]);
disp(['     pixel encoding index = ',num2str(hcst_andor_getPixelEncodingIndex(B))]);
disp(['     image size (bytes) = ',num2str(hcst_andor_getImageSizeBytes(B))]);
disp(['     AOIHeight = ',num2str(B.bench.andor.AOIHeight)]);
disp(['     AOIWidth  = ',num2str(B.bench.andor.AOIWidth)]);
disp(['     AOIStride = ',num2str(B.bench.andor.AOIStride)]);


hcst_andor_setSensorCooling(B,true,wait2stabilize);

B.bench.andor.CONNECTED = true;

end