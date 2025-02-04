function cost = costTotal(origin,originTransform,transform,ptCloud,pc,pedicleCenterPoint)
    direction = genTraj(originTransform,transform);
    [~,costBoundary] = findClosestPointToLine(ptCloud,origin,direction);

    pc = [1 1 1];

    costAngle = atan2(norm(cross(direction,pc)),dot(direction,pc));

    costDist = pointToLineDistance(pedicleCenterPoint,origin,direction);

    cost = 300*costDist + costAngle +1/30*costBoundary;
end