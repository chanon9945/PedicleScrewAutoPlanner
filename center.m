function [center,centerX,centerY] = center(shape)
    nonZeroMask = shape > 0;
    [xnew, ynew] = ndgrid(1:size(shape, 1), 1:size(shape, 2));

    centerX = round(mean(xnew(nonZeroMask)));
    centerY = round(mean(ynew(nonZeroMask)));
    
    center = [centerX, centerY];
end