function plotPCAWithPointCloud(ptCloud)
    % Perform PCA on the point cloud
    [coeff, ~, latent] = pca(ptCloud.Location);

    % Compute the mean center of the point cloud
    meanPoint = mean(ptCloud.Location, 1);

    % Scale PCA vectors for visualization (proportional to variance)
    scalingFactor = sqrt(latent) * 2;  % Adjust scale based on variance
    pcaVectors = coeff .* scalingFactor';  % Scale eigenvectors

    % Plot the point cloud
    figure;
    pcshow(ptCloud, 'MarkerSize', 50);
    hold on;
    title('Point Cloud with PCA Axes');
    xlabel('X'); ylabel('Y'); zlabel('Z');

    % Plot PCA vectors using quiver3
    quiver3(meanPoint(1), meanPoint(2), meanPoint(3), ...
        pcaVectors(1,1), pcaVectors(2,1), pcaVectors(3,1), ...
        'r', 'LineWidth', 3, 'MaxHeadSize', 2);  % First principal component (Red)

    quiver3(meanPoint(1), meanPoint(2), meanPoint(3), ...
        pcaVectors(1,2), pcaVectors(2,2), pcaVectors(3,2), ...
        'g', 'LineWidth', 3, 'MaxHeadSize', 2);  % Second principal component (Green)

    quiver3(meanPoint(1), meanPoint(2), meanPoint(3), ...
        pcaVectors(1,3), pcaVectors(2,3), pcaVectors(3,3), ...
        'b', 'LineWidth', 3, 'MaxHeadSize', 2);  % Third principal component (Blue)

    hold off;
    grid on;
end
