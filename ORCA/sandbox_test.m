centerrow = col;
framesize = 100;
framecheck=false;
for i = 1:1:10
    % Ensure framesize is a multiple of 4
    if mod(framesize, 4) ~= 0
        framesize_round = ceil(framesize / 4) * 4;  % Round framesize to nearest multiple of 4
    else
        framesize_round = framesize;
    end
    disp(['framsize ceil: ', num2str(framesize_round)])

    [centercoord, framesize] = adjust_paramters4(centerrow, framesize_round);
    
    if framesize_round == framesize
        disp('found soln')
        framecheck = true;
        break
    else 
        framesize = framesize + 8;
        disp(num2str(framesize))
    end
end

if ~framecheck
    error('could not find framesize and border coord to meet orca reqs')

end

disp('continued code')
% % Define parameters
% centerrow = 100;   % Example value
% framesize = 15;    % Example value

function [centercoord, framesize] = adjust_paramters4(centercoord, framesize)

    
    % Calculate the initial top based on centerrow and framesize
    top = centercoord - framesize / 2;
    
    % Ensure top is a multiple of 4
    if mod(top, 4) ~= 0
        % Adjust top to be a multiple of 4
        top = ceil(top / 4) * 4;
        
        % Recalculate framesize to maintain the correct relationship with top
        framesize = (centercoord - top)*2;
    end
    
    % Display the adjusted values
    fprintf('Adjusted top: %d\n', top);
    fprintf('Adjusted framesize: %d\n', framesize);
end

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