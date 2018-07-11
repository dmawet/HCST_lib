function hcst_andor_testLib(B)
%hcst_Andor_testLib Function to test the Andor commands
%
%   
%   Inputs:
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_Andor_testLib(Bench)
%           Runs through the available MATLAB Andor commands
%
%
%   See also: hcst_testLib, hcst_setUpBench, hcst_cleanUpBench
%


%% Execute the functions/commands, one-by-one


im = hcst_andor_getImage(B);


figure;
imagesc(double(im)/2^16);
axis image; 
colorbar;
title('Normalized image');

end