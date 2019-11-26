function [xT, yT, zT] = TranslationData(dx, dy, dz)
    %Rotation data X-Y
    randR = rand * 360;
    xR = dx*cosd(randR) + dy*sind(randR);
    yR = -dx*sind(randR) + dy*cosd(randR);
    
    %Rotation data Y-Z
    randR = rand * 360;
    zR = yR*cosd(randR) + dz*sind(randR);
    yR = -yR*sind(randR) + dz*cosd(randR);

    %Translation data
    randTx = 2 - (rand * 4);
    randTy = 2 - (rand * 4);
    randTz = 1 - (rand * 2);
    xT = xR + randTx;
    yT = yR + randTy;
    zT = zR + randTz + 1.5;
end