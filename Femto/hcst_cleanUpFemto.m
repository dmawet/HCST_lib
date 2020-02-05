% Close the Labjack/Femto connection and clean up the bench struct

function hcst_cleanUpFemto(bench)

%% Close the connection and populate the bench struct accordingly
py.labjack.ljm.close(bench.Femto.LJ.handle)

%ljm.close doesn't return anything, and trying to read a value after
%closure will throw an error/halt the program, so just assume for now.
bench.Femto.CONNECTED = false; 

bench.Femto = rmfield(bench.Femto, 'LJ');

disp('*** Labjack T7 disconnected. ***')
% Save backup bench object
hcst_backUpBench(bench)

end