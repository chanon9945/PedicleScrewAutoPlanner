function [shape,stackX,stackY] = dfs(image, imageSize, i, j, shape, stackX, stackY)
    if i < 1 || j < 1 || i > imageSize(1) || j > imageSize(2) || image(i,j) == 1 || shape(i,j) == 1
        return;
    end

    shape(i, j) = 1;
    stackX = [stackX ; i];
    stackY = [stackY ; j];

    [shape,stackX,stackY] = dfs(image, imageSize, i+1, j, shape,stackX,stackY);
    [shape,stackX,stackY] = dfs(image, imageSize, i-1, j, shape,stackX,stackY);
    [shape,stackX,stackY] = dfs(image, imageSize, i, j+1, shape,stackX,stackY);
    [shape,stackX,stackY] = dfs(image, imageSize, i, j-1, shape,stackX,stackY);
end