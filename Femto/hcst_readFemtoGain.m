% Read the digital I/O ports on the Labjack.  With the Femto connected,
% FIO0 = LSB, FIO1 = Middle bit, FIO2 = MSB, FIO3 = High/Low gain switch
% (HIGH/1 is low gain, LOW/0 is high gain).  This script also prints the
% current gain setting of the Femto.

function [ G ] = hcst_readFemtoGain(bench)

%% Read the DIO ports, print the current values, and the corresponding gain setting

%Must use DIO_STATE here instead of directly reading the port to prevent
%them being set as inputs
bench.Femto.LJ.DIOstate = py.labjack.ljm.eReadName(bench.Femto.LJ.handle, "DIO_STATE");

diff = bench.Femto.LJ.DIOstate - 8388592; %Const here is 2^23 - 16; DIO_STATE returns 23-digit binary
pin_list = dec2bin(diff, 4);

% fprintf("Current Femto Pin Settings:\nPin 10 (LSB):  %i\nPin 11 (Middle):  %i\nPin 12 (MSB):"...
%         + "  %i\nPin 14 (Lo/Hi Gain):  %i\n", ...
%         str2num(pin_list(4)), str2num(pin_list(3)), str2num(pin_list(2)), ...
%         str2num(pin_list(1)))

bench.Femto.LoHiGain = str2num(pin_list(1));

if(bench.Femto.LoHiGain == 1)
    gain = 1e3;
else
    gain = 1e5;
    
bench.Femto.gain = gain*10^bin2dec(pin_list(2:4));
G = bench.Femto.gain;

fprintf("Current Femto Gain Setting: %e V/M\n", bench.Femto.gain)

clear diff pin_list gain
    
end