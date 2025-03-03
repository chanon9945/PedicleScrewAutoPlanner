function [H1Mean,H2Mean,H1,H2,jnt1Lim,jnt2Lim] = generateWorkspace(resolution,length)
    jnt1Lim = linspace(-180,180,resolution);
    jnt2Lim = linspace(-90,90,resolution);
    H1 = zeros(4,4,resolution);
    H2 = zeros(4,4,resolution);

    for i = 1:resolution
        H1(:,:,i) = rotm2tform(roty(jnt1Lim(i)));
    end

    for i = 1:resolution
        H2(:,:,i) = rotm2tform(rotz(jnt2Lim(i)))*trvec2tform([0,length,0]);
    end

    %Calculate Means of Homogenous Transforms
    %Using Monte Carlo Integration:
    
    %Mean of Rotation Matrices
    H1MeanM = MCmean(H1(1:3,1:3,:),resolution);
    H2MeanM = MCmean(H2(1:3,1:3,:),resolution);

    %Format Correction
    H1MeanR = Mcorrection(H1MeanM);
    H2MeanR = Mcorrection(H2MeanM);

    %Mean of Translation
    H1Meana = MCmean(H1(1:3,4,:),resolution)';
    H2Meana = MCmean(H2(1:3,4,:),resolution)';

    %Combined Mean
    H1Mean = se3(H1MeanR,H1Meana);
    H2Mean = se3(H2MeanR,H2Meana);

end
