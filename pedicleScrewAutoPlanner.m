clear
close all
clc

tic;
%Generate virtual robot workspace
resolution = 1000;
reach = 100;
weight = [300 1 30 0.05];
[H1Mean,H2Mean,H1,H2,jnt1Lim,jnt2Lim] = generateWorkspace(resolution,reach);
stage1Time = toc;

tic;
%Load raw images
rawImage = niftiread("Panoramix-cropped.nii");
mask = niftiread("Panoramix-cropped segmentation-L4 vertebra-label.nii");

%Resample the volume
[resampledMask,resampledVol] = resample(rawImage,mask,[0.7421875 0.7421875],1.5);
resampledVol = double(resampledMask).*double(resampledVol);

%Find the centroid
[centroidLoc,centroidX,centroidY,centroidZ] = centroid(resampledMask);

%Surgeon specify the insertion point (WIP)
insertionPoint = [190 120 161];
insertionTransform = se3(trvec2tform(insertionPoint));

%Shift the seed point to a point inside the spinal canal
[shiftedX, shiftedY] = centroidShift(centroidX,centroidY,centroidZ,resampledMask);

%Use floodfilling to find the area of the spinal canal and find the center
%of the canal
[spinalCanal,stackX,stackY] = floodfill(resampledMask(:,:,centroidZ),shiftedX,shiftedY);
canalMaxY = max(stackY);
canalMinY = min(stackY);
[canalCenter,canalCenterX,canalCenterY] = center(spinalCanal);

%Cut the pedicle out using the spinal canal border as guide
pedicle = cutPedicle(resampledVol,canalMaxY,canalMinY,15,1);
pedicleMask = cutPedicle(resampledMask,canalMaxY,canalMinY,15,1);

%Cut out only the relevant side of the pedicle
pedicleROI = pedicleROICut(pedicle,insertionPoint(1),centroidX);
pedicleROIMask = pedicleROICut(pedicleMask,insertionPoint(1),centroidX);

%Using PCA to find the axes of the pedicle
pediclePtCloud = voxelToPointCloud(pedicleROIMask);
[pedicleCoeff,~,pedicleLatent] = pca(pediclePtCloud.Location);
pedicleCenterPoint = mean(pediclePtCloud.Location,1);
scalingFactor = sqrt(pedicleLatent)*2;
pcaVectors = pedicleCoeff .* scalingFactor';

%Extract the surface point of the pedicle
vertebraSurf = extractSurfaceVoxels(resampledMask);

ptCloud = voxelToPointCloud(vertebraSurf);
stage2Time = toc;

tic;
%Allocating memmory for the search algorithm
HTemp = H1Mean*H2Mean*insertionTransform;
costTemp1 = zeros(resolution,1);
costTemp2 = zeros(resolution,1);

%Search in H1
for i = 1:resolution
    costTemp1(i) = costTotal(insertionPoint,insertionTransform,...
        insertionTransform*se3(H1(:,:,i))*H2Mean,ptCloud,pcaVectors(:,3)',pedicleCenterPoint,weight,resampledVol,reach);
    disp("Searching 1st link")
    disp([num2str(i) '\' num2str(resolution)])
end

[~,ITemp1] = min(costTemp1);
H1Final = se3(H1(:,:,ITemp1));
jnt1Final = jnt1Lim(ITemp1);

%Search in H2
for i = 1:resolution
    costTemp2(i) = costTotal(insertionPoint,insertionTransform,...
        insertionTransform*H1Final*se3(H2(:,:,i)),ptCloud,pcaVectors(:,3)',pedicleCenterPoint,weight,resampledVol,reach);
    disp("Searching 2nd link")
    disp([num2str(i) '\' num2str(resolution)])
end

[costFinal,ITemp2] = min(costTemp2);
H2Final = se3(H2(:,:,ITemp2));
jnt2Final = jnt2Lim(ITemp2);

%Generate the final trajectory as vector
finalTraj = genTraj(insertionTransform,insertionTransform*H1Final*H2Final);
stage3Time = toc;

%Convert final transform to pedicle screw angle
trajProjectedYZ = [0,finalTraj(2),finalTraj(3)];
pitchAngle = rad2deg(atan2(norm(cross([0 1 0],trajProjectedYZ)),dot([0 1 0],trajProjectedYZ)));
trajProjectedXY = [finalTraj(1),finalTraj(2),0];
yawAngle = rad2deg(atan2(norm(cross([0 1 0],trajProjectedXY)),dot([0 1 0],trajProjectedXY)));

%Summarize total time used
totalTime = stage1Time + stage2Time + stage3Time;
disp("Total Time: " + totalTime + " s")
disp("Stage 1 (Workspace Generation) Time: " + stage1Time + "s")
disp("Stage 2 (Image and Volume Processing) Time: " + stage2Time + "s")
disp("Stage 3 (Search) Time: " + stage3Time + "s")
disp("Pitch: " + pitchAngle + "deg")
disp("Yaw: " + yawAngle + "deg")

%Plot Final Trajectory
% Define the line (vector)
lineOrigin = insertionPoint;  % Define start point of the line
lineDirection = finalTraj; % Direction vector
lineLength = reach;            % Length of the line

% Compute line endpoints
lineEnd = lineOrigin + lineDirection * lineLength;

% Plot the pointcloud
figure;
pcshow(ptCloud)
hold on;

% Plot the line using plot3
plot3([lineOrigin(1), lineEnd(1)], ...
      [lineOrigin(2), lineEnd(2)], ...
      [lineOrigin(3), lineEnd(3)], 'r-', 'LineWidth', 1);

% Add labels and formatting
title('Pointcloud with Line Overlay');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
grid on;
view(3);  % Set 3D view
camlight; lighting phong;
hold off;