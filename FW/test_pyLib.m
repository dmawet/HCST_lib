clear; 

disp('Connecting to FW ...')

HCST_lib_PATH = '/home/hcst/HCST_lib/FW';
if count(py.sys.path, HCST_lib_PATH) == 0
    insert(py.sys.path, int32(0), HCST_lib_PATH);
end

import fw102c.*

fwl = py.fw102c.FW102C();

disp('FW connected.')

% disp('Cycling positions...')
% fwl.command('pos=1');
% fwl.command('pos=2');
% fwl.command('pos=3');
% fwl.command('pos=4');
% fwl.command('pos=5');
% fwl.command('pos=6');
% disp('Done.')

disp('Cycling positions...')
fwl.command('pos=1');
fwl.command('pos=4');
fwl.command('pos=1');
disp('Done.')

fwl.query('pos?')


return;
%%

fwl.close();
disp('FW connection closed.')
