function [closestPoint, minDistance] = findClosestPointToLine(ptCloud, lineOrigin, lineDirection)
    % Normalize the line direction to ensure correct projections
    lineDirection = lineDirection / norm(lineDirection);

    % Extract point cloud locations
    points = ptCloud.Location;  % Nx3 matrix

    % Compute projection scalars t for all points
    t = sum((points - lineOrigin) .* lineDirection, 2) ./ sum(lineDirection .* lineDirection);

    % Compute the closest points on the line
    projectedPoints = lineOrigin + t .* lineDirection;

    % Compute Euclidean distances
    distances = vecnorm(points - projectedPoints, 2, 2);

    % Find the minimum distance and corresponding closest point
    [minDistance, idx] = min(distances);
    closestPoint = points(idx, :);
end
