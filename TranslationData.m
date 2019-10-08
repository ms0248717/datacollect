function [xT, yT, zT] = TranslationData(dx, dy, dz)
    %Rotation data
    randR = rand * 360;
    xR = dx*cosd(randR) + dy*sind(randR);
    yR = -dx*sind(randR) + dy*cosd(randR);

    %Translation data
    randTx = 2 - (rand * 4);
    randTy = 2 - (rand * 4);
    randTz = 0.15 - (rand * 0.3);
    xT = xR + randTx;
    yT = yR + randTy;
    zT = dz + randTz + 1.5;
end