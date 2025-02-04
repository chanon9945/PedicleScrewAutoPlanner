function distance = pointToLineDistance(point, lineOrigin, lineDirection)
    % Normalize the line direction vector
    lineDirection = lineDirection / norm(lineDirection);

    % Compute vector from the line origin to the point
    vecToPoint = point - lineOrigin;

    % Compute cross product to find perpendicular distance
    crossProd = cross(vecToPoint, lineDirection);

    % Compute the distance
    distance = norm(crossProd) / norm(lineDirection);
end
