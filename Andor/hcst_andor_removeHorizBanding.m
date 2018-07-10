function im = hcst_andor_removeHorizBanding(im,mask)
%im = hcst_andor_removeHorizBanding(im)
% Removes horizontal banding artifact in Andor Neo frames.

    [~,cols,dims] = size(im);% Get size of the input image/cube
    
    % loop through image slices in cube 
    for dimIndex = 1:dims
        
        % Get slice 
        imslice = im(:,:,dimIndex);
        
        % Check if a mask has been passed.
        if(~isempty(mask))
            imslice(~mask) = nan;
        end
        
        % Take the median in the horizontal direction
        horizMedian = nanmedian(imslice,2);
        
        % Repeat the horizontal median to create estimate of banding
        bandIm = repmat(horizMedian,1,cols);
        
        % Subtract banding from the slice 
        im(:,:,dimIndex) = im(:,:,dimIndex) - bandIm;
    end
    

end

