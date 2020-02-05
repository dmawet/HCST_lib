% hcstr_realignFPMAndRecenter.m
%
% to be used during EFC iterations to realign the FPM and recenter the
% subwindow
%
% Jorge Llop - May 08, 2019

function [bench] = hcstr_realignFPMAndRecenter(bench,mp)
    tint0 = bench.andor.tint;
    if true
        recenter_wWaffle
    end
    %% Realign FPM
    fprintf(['Fine alignment of FPM' '\n' ]);
     hcst_andor_setExposureTime(bench,tint0);
    [bench] = hcstr_FPM_fineAlignment(bench,mp,false);
     hcst_andor_setExposureTime(bench,tint0);
end
