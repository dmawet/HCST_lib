clear; 

bench = hcst_config();

hcst_setUpFW(bench);

%%

bench.FW.currentPos

disp('Cycling positions...')
hcst_FW_setPos(bench,3);
hcst_FW_setPos(bench,4);
resPos = hcst_FW_setPos(bench,2)
disp('Done.')

bench.FW.currentPos

%%

hcst_cleanUpFW(bench)
disp('FW connection closed.')
