function voxelMatrix = bresenham3D(origin, endpoint, matrix)
    matrixSize = size(matrix);
    % bresenham3D_embedded Draws a 3D line between origin and endpoint and
    % embeds it in a voxel matrix of size matrixSize.
    %
    % INPUTS:
    %   origin     - 1x3 vector [x y z] for the start point.
    %   endpoint   - 1x3 vector [x y z] for the end point.
    %   matrixSize - 1x3 vector [Nx Ny Nz] defining the size of the voxel matrix.
    %
    % If the provided origin and endpoint are already within the index ranges
    % [1, Nx] (for x), [1, Ny] (for y) and [1, Nz] (for z), they are used directly.
    % Otherwise, the points are mapped uniformly so that the line “fits” inside
    % the matrix (with the origin mapping to 1 and the endpoint mapping to the maximum index).
    
    Nx = matrixSize(1); Ny = matrixSize(2); Nz = matrixSize(3);
    
    % Round the endpoints to integers
    x1 = round(origin(1)); y1 = round(origin(2)); z1 = round(origin(3));
    x2 = round(endpoint(1)); y2 = round(endpoint(2)); z2 = round(endpoint(3));
    
    % Calculate differences and signs
    dx = abs(x2 - x1); dy = abs(y2 - y1); dz = abs(z2 - z1);
    sx = sign(x2 - x1); sy = sign(y2 - y1); sz = sign(z2 - z1);
    
    % Determine number of steps from the dominant axis.
    if dx >= dy && dx >= dz
        nsteps = dx + 1;
    elseif dy >= dx && dy >= dz
        nsteps = dy + 1;
    else
        nsteps = dz + 1;
    end
    
    % Preallocate coordinate list
    coords = zeros(nsteps, 3);
    coords(1,:) = [x1, y1, z1];
    
    % Use the dominant axis for iteration.
    idx = 2;
    if dx >= dy && dx >= dz
        err1 = 2*dy - dx;
        err2 = 2*dz - dx;
        while x1 ~= x2
            if err1 > 0
                y1 = y1 + sy;
                err1 = err1 - 2*dx;
            end
            if err2 > 0
                z1 = z1 + sz;
                err2 = err2 - 2*dx;
            end
            err1 = err1 + 2*dy;
            err2 = err2 + 2*dz;
            x1 = x1 + sx;
            coords(idx,:) = [x1, y1, z1];
            idx = idx + 1;
        end
    elseif dy >= dx && dy >= dz
        err1 = 2*dx - dy;
        err2 = 2*dz - dy;
        while y1 ~= y2
            if err1 > 0
                x1 = x1 + sx;
                err1 = err1 - 2*dy;
            end
            if err2 > 0
                z1 = z1 + sz;
                err2 = err2 - 2*dy;
            end
            err1 = err1 + 2*dx;
            err2 = err2 + 2*dz;
            y1 = y1 + sy;
            coords(idx,:) = [x1, y1, z1];
            idx = idx + 1;
        end
    else
        err1 = 2*dx - dz;
        err2 = 2*dy - dz;
        while z1 ~= z2
            if err1 > 0
                x1 = x1 + sx;
                err1 = err1 - 2*dz;
            end
            if err2 > 0
                y1 = y1 + sy;
                err2 = err2 - 2*dz;
            end
            err1 = err1 + 2*dx;
            err2 = err2 + 2*dy;
            z1 = z1 + sz;
            coords(idx,:) = [x1, y1, z1];
            idx = idx + 1;
        end
    end
    
    % Clip coordinates to matrix bounds (if necessary)
    valid = coords(:,1)>=1 & coords(:,1)<=Nx & ...
            coords(:,2)>=1 & coords(:,2)<=Ny & ...
            coords(:,3)>=1 & coords(:,3)<=Nz;
    coords = coords(valid, :);
    
    % Create the voxel matrix and set all computed coordinates at once
    voxelMatrix = zeros(Nx, Ny, Nz);
    indices = sub2ind([Nx, Ny, Nz], coords(:,1), coords(:,2), coords(:,3));
    voxelMatrix(indices) = 1;
end