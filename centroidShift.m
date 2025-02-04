function [shiftedX, shiftedY] = centroidShift(coordinateX, coordinateY, coordinateZ, maskIn)
    if coordinateY <= 1
        shiftedX = coordinateX;
        shiftedY = coordinateY;
        return;
    end

    if maskIn(coordinateX, coordinateY, coordinateZ) == 0
        shiftedX = coordinateX;
        shiftedY = coordinateY;
    else
        [shiftedX, shiftedY] = centroidShift(coordinateX, coordinateY-1, coordinateZ, maskIn);
    end
end

