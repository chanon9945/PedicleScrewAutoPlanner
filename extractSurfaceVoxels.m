function surfaceVoxels = extractSurfaceVoxels(volume)
    % Use bwperim to find the surface voxels
    surfaceVoxels = bwperim(volume);
end
