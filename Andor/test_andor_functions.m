% set of functions for andor camera
%
andor_handle = bench.andor.andor_handle;
%%
tint = 1e-5;
hcst_andor_setExposureTime(bench,tint);

centrow = bench.andor.FocusRow;
centcol = bench.andor.FocusCol;
cropsize = 64;
% centrow = bench.andor.PupRow;
% centcol = bench.andor.PupCol;
% cropsize = 700;
hcst_andor_setSubwindow(bench,centrow,centcol,cropsize);
%%
hcst_andor_toggleAcq(bench, false);
hcst_andor_toggleContinuousMode(bench,false);
tic;
im = hcst_andor_getImage(bench);
imTime = toc;
disp(['frequency = ',num2str(1/imTime)])

%%
framerate = 1000;
numim = 100; 

hcst_andor_toggleContinuousMode(bench,true);
hcst_andor_toggleAcq(bench, true);
hcst_andor_setFrameRate(bench,framerate);

im_series = zeros(numim, bench.andor.AOIHeight,bench.andor.AOIWidth);
tic;
for coadd = 1:numim
    im = hcst_andor_getImage(bench);
    im_series(coadd,:,:) = im;
end
imTime = toc;
disp(['frequency = ',num2str(numim/imTime)])
hcst_andor_toggleAcq(bench, false);


%% Get Max Frame Rate

% Equivalent to AT_SetFloat(Handle, L"FrameRate", 100);
featurePtr = libpointer('voidPtr',[int32('FrameRate'),0]);
queryPtr = libpointer('voidPtr',10);
err = calllib('lib', 'AT_GetFloatMax', andor_handle, featurePtr, queryPtr);
if(err~=0)
    disp('Failed to get the max frame rate.');
    error(['Andor lib ERROR:',num2str(err),' AT_GetFloatMax']);
end
query = get(queryPtr);
maxrate = query.Value;
disp(['maxrate = ',num2str(maxrate)])

%% Get Frame Rate

% Equivalent to AT_SetFloat(Handle, L"FrameRate", 100);
featurePtr = libpointer('voidPtr',[int32('FrameRate'),0]);
queryPtr = libpointer('voidPtr',10);
err = calllib('lib', 'AT_GetFloat', andor_handle, featurePtr, queryPtr);
if(err~=0)
    disp('Failed to get the frame rate.');
    error(['Andor lib ERROR:',num2str(err),' AT_GetFloat']);
end
query = get(queryPtr);
rate = query.Value;
disp(['rate = ',num2str(rate)])

%% Get Cycle Mode;
featurePtr = libpointer('voidPtr',int32(['CycleMode',0]));
queryPtr = libpointer('voidPtr',int32(10));
err = calllib('lib', 'AT_GetEnumIndex', andor_handle, featurePtr, queryPtr);

if(err~=0)
    disp('Failed to get the cycle mode.');
    error(['Andor lib ERROR:',num2str(err),' AT_GetEnumIndex']);
end
query = get(queryPtr);
cycleMode = query.Value;
disp(['cycleMode = ',num2str(cycleMode)])

%% Set Cycle Mode
continuousMode = true;

featurePtr = libpointer('voidPtr',int32(['CycleMode',0]));
err = calllib('lib', 'AT_SetEnumIndex', andor_handle, featurePtr, int32(continuousMode));

if(err~=0)
    disp('Failed to set the cycle mode.');
    error(['Andor lib ERROR:',num2str(err),' AT_SetEnumIndex']);
end


featurePtr = libpointer('voidPtr',int32(['CycleMode',0]));
queryPtr = libpointer('voidPtr',int32(10));
err = calllib('lib', 'AT_GetEnumIndex', andor_handle, featurePtr, queryPtr);

if(err~=0)
    disp('Failed to get the cycle mode.');
    error(['Andor lib ERROR:',num2str(err),' AT_GetEnumIndex']);
end
query = get(queryPtr);
cycleMode = query.Value;
disp(['cycleMode = ',num2str(cycleMode)])


%% Get Frame Count;
featurePtr = libpointer('voidPtr',int32(['FrameCount',0]));
queryPtr = libpointer('voidPtr',int32(10));
err = calllib('lib', 'AT_GetInt', andor_handle, featurePtr, queryPtr);

if(err~=0)
    disp('Failed to get the FrameCount.');
    error(['Andor lib ERROR:',num2str(err),' AT_GetInt']);
end
query = get(queryPtr);
frameCount = query.Value;
disp(['frameCount = ',num2str(frameCount)])

%% Get Frame Rate;
featurePtr = libpointer('voidPtr',int32(['FrameRate',0]));
queryPtr = libpointer('voidPtr', 10);
err = calllib('lib', 'AT_GetFloat', andor_handle, featurePtr, queryPtr);

if(err~=0)
    disp('Failed to get the FrameRate.');
    error(['Andor lib ERROR:',num2str(err),' AT_GetFloat']);
end
query = get(queryPtr);
frameRate = query.Value;
disp(['frameRate = ',num2str(frameRate)])

%% Set Frame Rate;
frameRateValue = 10;
featurePtr = libpointer('voidPtr',int32(['FrameRate',0]));
err = calllib('lib', 'AT_SetFloat', andor_handle, featurePtr, frameRateValue);

if(err~=0)
    disp('Failed to get the FrameRate.');
    error(['Andor lib ERROR:',num2str(err),' AT_SetFloat']);
end