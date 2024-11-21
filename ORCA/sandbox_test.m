hcst_orca_setSubwindowFullframe(bench)

hcst_orca_setBinning(bench, 1);
image = hcst_orca_getSingleFrame(bench); figure(1); imagesc(((image))); colorbar;

[maxVal, ~] = max(image(:)); [rowf, colf] = find(image == maxVal)

bench.orca.subwindow_shift = 'topleft';

hcst_orca_setSubwindow(bench, rowf, colf, 100)


image2 = hcst_orca_getSingleFrame(bench); 

figure(2); imagesc(((image2))); colorbar;

[maxVal, ~] = max(image2(:)); [rowsw, colsw] = find(image2 == maxVal)

%%
image_sq = hcst_orca_cropSubwindowSquare(bench,image2);

figure(22)
imagesc(image_sq)
[rowsq, colsq] = find(image_sq == max(image_sq(:)))

%%

img_rect = image2;

img_tmp = img_rect(bench.orca.crop_row+1:(bench.orca.AOIHeight+bench.orca.crop_row), bench.orca.crop_col+1:(bench.orca.AOIWidth+bench.orca.crop_col));
[maxVal, ~] = max(img_tmp(:)); [row3, col3] = find(img_tmp == maxVal)

figure(11);
imagesc(img_tmp)

%%
image_get = hcst_orca_getImage(bench);

figure(22)
imagesc(image_get)

[rowg, colg] = find(image_get == max(image_get(:)))

%%

% Step 2: adjust frame to be square:

% Get the center of the matrix
[m, n] = size(img_tmp);               % Get the dimensions of the matrix

center_row = floor(m / 2) + 1;  % Center row index
center_col = floor(n / 2) + 1;  % Center column index

square_size = min([m,n]);

% Calculate the indices of the square around the center
half_size = floor(square_size / 2);   % Half size of the square

% Define the row and column range for the square
row_range = (center_row - half_size):(center_row + half_size);
col_range = (center_col - half_size):(center_col + half_size);

% Ensure that the indices are within bounds of the matrix
row_range = max(1, row_range);
row_range = min(m, row_range);

col_range = max(1, col_range);
col_range = min(n, col_range);

% Extract the square region
img = img_tmp(row_range, col_range);

figure(12);
imagesc(img)
[maxVal, ~] = max(img(:)); [row_final, col_final] = find(img == maxVal)

%%
[rowsw, colsw] = find(image3 == max(image3(:)))

% centerrow = col;
% framesize = 100;
% framecheck=false;
% for i = 1:1:10
%     % Ensure framesize is a multiple of 4
%     if mod(framesize, 4) ~= 0
%         framesize_round = ceil(framesize / 4) * 4;  % Round framesize to nearest multiple of 4
%     else
%         framesize_round = framesize;
%     end
%     disp(['framsize ceil: ', num2str(framesize_round)])
% 
%     [centercoord, framesize] = adjust_paramters4(centerrow, framesize_round);
%     
%     if framesize_round == framesize
%         disp('found soln')
%         framecheck = true;
%         break
%     else 
%         framesize = framesize + 8;
%         disp(num2str(framesize))
%     end
% end
% 
% if ~framecheck
%     error('could not find framesize and border coord to meet orca reqs')
% 
% end
% 
% disp('continued code')
% % % Define parameters
% % centerrow = 100;   % Example value
% % framesize = 15;    % Example value
% 
% function [centercoord, framesize] = adjust_paramters4(centercoord, framesize)
% 
%     
%     % Calculate the initial top based on centerrow and framesize
%     top = centercoord - framesize / 2;
%     
%     % Ensure top is a multiple of 4
%     if mod(top, 4) ~= 0
%         % Adjust top to be a multiple of 4
%         top = ceil(top / 4) * 4;
%         
%         % Recalculate framesize to maintain the correct relationship with top
%         framesize = (centercoord - top)*2;
%     end
%     
%     % Display the adjusted values
%     fprintf('Adjusted top: %d\n', top);
%     fprintf('Adjusted framesize: %d\n', framesize);
% end

% 
% if ~mod(framesize, 4)
%     % do nothing, framesize can be any multiple of 100 
% else
% 
%     aoi_min_try = centercoord - framesize/2;
%     aoi_max_try = centercoord + framesize/2;
%     
%     % aoi_max_try is not a multiple of 100 or a factor of 2^n
%     if mod(aoi_max_try, 100) && mod(log2(aoi_max_try), 1)
% 
%     end
%     
% 
% 
% end
% 
% 
% aoi_try = centercol - framesize/2
% 
% % If AOI is not a multiple of 100
% if mod(aoi_try, 100)
%     nearest_multiple_of_100 = round(aoi_try / 100) * 100
%     
%     % Calculate the difference from the nearest multiple
%     difference = aoi_try - nearest_multiple_of_100
%     
%     
%     if abs(difference) < 30
%         disp('small diff')
%         aoi_real = nearest_multiple_of_100
%         framesize_new = framesize + 2*difference
%     
%     else
%         disp('big diff')
%         % use floor since we are going top left
%         aoi_real = floor(aoi_try / 100) * 100
%         difference = aoi_try - aoi_real
%         framesize_new = framesize + 2*difference
%     
%     end
% end
% 
% 
% function [aoi_real, framesize_new] = get_shifted_aoi_coord(centercoord, framesize)
% 
% aoi_try = centercoord - framesize/2;
% 
% % If AOI is not a multiple of 100
% if mod(aoi_try, 100)
%     nearest_multiple_of_100 = round(aoi_try / 100) * 100;
%     
%     % Calculate the difference from the nearest multiple
%     difference = aoi_try - nearest_multiple_of_100;
%     
%     
%     if abs(difference) < 30
%         disp('small diff')
%         aoi_real = nearest_multiple_of_100;
%         framesize_new = framesize + 2*difference;
%     
%     else
%         disp('big diff')
%         % use floor since we are going top left
%         aoi_real = floor(aoi_try / 100) * 100;
%         difference = aoi_try - aoi_real;
%         framesize_new = framesize + 2*difference;
%     
%     end
% end
% 
% 
% end