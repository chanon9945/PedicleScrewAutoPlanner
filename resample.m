function [resampledMask,resampledVol] = resample(volIn,mask,pixelSpacing,layerSpacing)
    
    meanVal = mean(mask,"all");
    mask = mask >= meanVal;
    mask = double(mask);

    vol = double(volIn);

    % Define the original grid
    [x, y, z] = ndgrid(1:size(vol, 1), 1:size(vol, 2), 1:size(vol, 3));

    % Define the new uniform grid
    newSpacing = min([pixelSpacing, layerSpacing]);  % Use the smallest spacing
    newSizeX = round(size(vol, 1) * pixelSpacing(1) / newSpacing);
    newSizeY = round(size(vol, 2) * pixelSpacing(2) / newSpacing);
    newSizeZ = round(size(vol, 3) * layerSpacing / newSpacing);
    
    [xq, yq, zq] = ndgrid(linspace(1, size(vol, 1), newSizeX), ...
                          linspace(1, size(vol, 2), newSizeY), ...
                          linspace(1, size(vol, 3), newSizeZ));

    % Interpolate the volume data
    resampledVol = interpn(x, y, z, volIn, xq, yq, zq, 'nearest');
    resampledMask = interpn(x, y, z, mask, xq, yq, zq, 'nearest');
end