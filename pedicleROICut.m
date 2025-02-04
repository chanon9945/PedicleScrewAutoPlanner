function ROI = pedicleROICut(vol,roiPointX,centroidX)
    if roiPointX > centroidX
        vol(1:centroidX,:,:) = 0;
    else
        vol(centroidX:end,:,:) = 0;
    end

    ROI = vol;
end