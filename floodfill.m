function [filledShape,stackX,stackY] = floodfill(image,i,j)
    imageSize = size(image);
    shape = zeros(imageSize(1),imageSize(2));
    stackX = i;
    stackY = j;

    [filledShape,stackX,stackY] = dfs(image,imageSize,i,j,shape,stackX,stackY);
end