function d = genTraj(base,ee)
    ee_coord = trvec(ee);
    base_coord = trvec(base);

    X = ee_coord(1) - base_coord(1);
    Y = ee_coord(2) - base_coord(2); 
    Z = ee_coord(3) - base_coord(3);

    v = [X Y Z];
    d = v / norm(v);
end