function img = hcst_orca_cropSubwindowSquare(bench, img_rect)

    img = img_rect(bench.orca.crop_row+1:(bench.orca.AOIHeight+bench.orca.crop_row), bench.orca.crop_col+1:(bench.orca.AOIWidth+bench.orca.crop_col));

%     [maxVal, ~] = max(img_rect(:)); [row3, col3] = find(img_rect == maxVal)

    % Step 1: crop to centre PSF:
    % TODO: why is this factor of 4 reqd????
%     img_tmp = img_rect(4*bench.orca.crop_row+1:end, 4*bench.orca.crop_col+1:end);
% 
% %     [maxVal, ~] = max(img_tmp(:)); [row3, col3] = find(img_tmp == maxVal)
% 
%     figure(11);
%     imagesc(img_tmp)
% 
%     % Step 2: adjust frame to be square:
% 
%     % Get the center of the matrix
%     [m, n] = size(img_tmp);               % Get the dimensions of the matrix
%     center_row = floor(m / 2) + 1;  % Center row index
%     center_col = floor(n / 2) + 1;  % Center column index
% 
%     square_size = min([m,n]);
%     
%     % Calculate the indices of the square around the center
%     half_size = floor(square_size / 2);   % Half size of the square
%     
%     % Define the row and column range for the square
%     row_range = (center_row - half_size):(center_row + half_size);
%     col_range = (center_col - half_size):(center_col + half_size);
%     
%     % Ensure that the indices are within bounds of the matrix
%     row_range = max(1, row_range);
%     row_range = min(m, row_range);
%     
%     col_range = max(1, col_range);
%     col_range = min(n, col_range);
%     
%     % Extract the square region
%     img = img_tmp(row_range, col_range);
% 
%     figure(12);
%     imagesc(img)

%     [maxVal, ~] = max(img(:)); [row3, col3] = find(img == maxVal)


end