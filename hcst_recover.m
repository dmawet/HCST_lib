disp('Recovering...');

% Load the last bench back up
bench=hcst_loadLastBenchBackUp();

addpath('/opt/Boston Micromachines/lib/Matlab');

[notfound,warnings] = loadlibrary('libatcore','atcore.h','alias','lib');

disp('Last bench state:');
bench.isConnected

