function pedicle = cutPedicle(volIn,yMax,yMin,bufferFront,bufferEnd)

    volIn(:,1:yMin+bufferFront+1,:) = 0;
    volIn(:,yMax-bufferEnd:end,:) = 0;
    pedicle = volIn;

end