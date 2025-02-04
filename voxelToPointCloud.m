function ptCloud = voxelToPointCloud(voxelGrid)
    % Find indices of all occupied voxels (where voxelGrid == 1)
    [x, y, z] = ind2sub(size(voxelGrid), find(voxelGrid));

    % Convert to point cloud format
    ptCloud = pointCloud([x, y, z]);
end