function cost = costTotal(origin,originTransform,transform,ptCloud,pc,pedicleCenterPoint,weight,resampledVol,reach)
    direction = genTraj(originTransform,transform);
    lineLength = reach;
    lineEnd = origin + direction * lineLength;
    lineVoxel = bresenham3D(origin,lineEnd,resampledVol);
    [~,costBoundary] = findClosestPointToLine(ptCloud,origin,direction);

    costAngle = atan2(norm(cross(direction,pc)),dot(direction,pc));

    costDist = pointToLineDistance(pedicleCenterPoint,origin,direction);

    costDensity = sum(lineVoxel.*resampledVol,'all');

    cost = weight(1)*costDist + weight(2)*costAngle +1/weight(3)*costBoundary + weight(4)*costDensity;
end