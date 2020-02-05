%Set the gain setting on the Femto.  This assumes that the user always
%wants the high speed setting.

function [ G ] = hcst_setFemtoGain(bench, gainscale)

if(gainscale > 11 || gainscale < 5)
    warning("Femto gain is being set out of range.  Please choose a number" ...
            + "between 5 and 11 inclusive.\n")
end

bench.Femto.LoHiGain = int64(0); %LOW/0 is the high speed gain setting
gain_pin_dec_setting = gainscale - 5;
gain_pin_bin_setting = dec2bin(gain_pin_dec_setting, 3);
gain_pin_list = py.list();

for i=1:length(gain_pin_bin_setting)
    gain_pin_list.append(int64(str2num(gain_pin_bin_setting(i))));
end

gain_pin_list.append(bench.Femto.LoHiGain);

names = py.list({"FIO2", "FIO1", "FIO0", "FIO3"});
numFrames = int64(length(names));

py.labjack.ljm.eWriteNames(bench.Femto.LJ.handle, numFrames, names, gain_pin_list);

% G = hcst_readFemtoGain(bench);
G = 10^gainscale;
bench.Femto.gain = G;
% clear gain_pin_dec_setting gain_pin_bin_setting gainscale names numFrames gain_pin_list

end