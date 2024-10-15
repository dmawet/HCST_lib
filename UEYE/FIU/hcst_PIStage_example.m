%This is an example script showing the usage of the HCST-R PI stage code.
%It runs through the initialization script, homes each axis, moves each
%stage to a set position, rehomes them, and then shuts down the servos for
%each stage and severs the connection to the controller.

hcst_E873Controller_init(bench);

hcst_PIStage_home(bench);

bench.FIUstages.stage.PIdevice.qPOS()
testPos = [2, 1, 0.5];

hcst_PIStage_move(bench, testPos);

bench.FIUstages.stage.PIdevice.qPOS()

hcst_PIStage_home(bench);

bench.FIUstages.stage.PIdevice.qPOS()

hcst_PIStage_cleanUp(bench);