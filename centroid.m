function [centroid,centroidX,centroidY,centroidZ] = centroid(vol)
    nonZeroMask = vol > 0;
    [xnew, ynew, znew] = ndgrid(1:size(vol, 1), 1:size(vol, 2), 1:size(vol, 3));

    centroidX = round(mean(xnew(nonZeroMask)));
    centroidY = round(mean(ynew(nonZeroMask)));
    centroidZ = round(mean(znew(nonZeroMask)));
    
    centroid = [centroidX, centroidY, centroidZ];
end