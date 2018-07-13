%{
Script to test the hcst_[...] functions
******************************************************
This script runs through the hcst_[...] functions to check that they are
working correctly. It basically calls the individual test functions
associated with each device.
******************************************************
%}

%% Create and populate bench struct
fprintf("\n___Creating 'bench' struct\n")
bench = hcst_config();
hcst_setUpBench(bench);
fprintf("___'bench' struct created successfully\n\n")

%% Call FPM test function
fprintf("___Testing the FPM commands\n")
hcst_FPM_testLib(bench);
fprintf("___FPM commands completed\n\n")

%% Call LS test function
fprintf("___Testing the LS commands\n")
hcst_LS_testLib(bench);
fprintf("___LS commands completed\n\n")

%% Call TTM test function
fprintf("___Testing the TTM commands\n")
hcst_TTM_testLib(bench);
fprintf("___TTM commands completed\n\n")

%% Call Andor test function
fprintf("___Testing the Andor commands\n")
hcst_andor_testLib(bench);
fprintf("___Andor commands completed\n\n")


%% Call cleanUp
fprintf("___Testing cleanUp\n")
hcst_cleanUpBench(bench);
fprintf("___cleanUp completed\n\n")
