function [dx, dy, dz] = Position(ax, ay, az, freq)

    %define parameters
    
    dt = 1 / freq;

    %Center regulation
    sx = mean(ax(1:freq*2));
    sy = mean(ay(1:freq*2));
    sz = mean(az(1:freq*2));
    ax = ax - sx;
    ay = ay - sy;
    az = az - sz;
    ax = ax(freq*2:end);
    ay = ay(freq*2:end);
    az = az(freq*2:end);

    %Low pass filter
    windowSize = 5; 
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    ax = filter(b,a,ax);
    ay = filter(b,a,ay);
    az = filter(b,a,az);

    datasize = size(ax);

    %plot acceleration
    figure;
    subplot(3,1,1);
    plot(ax);
    xlabel('sample')
    ylabel('m/s^2')
    title('X-Acceleration')
    %axis([-inf, inf, -0.01, 0.01]);
    subplot(3,1,2)
    plot(ay);
    xlabel('sample')
    ylabel('m/s^2')
    title('Y-Acceleration')
    %axis([-inf, inf, -0.01, 0.01]);
    subplot(3,1,3)
    plot(az);
    xlabel('sample')
    ylabel('m/s^2')
    title('Z-Acceleration')
    %axis([-inf, inf, -0.01, 0.01]);
    %return

    %Convert to cm
    ax = ax .* 1000;
    ay = ay .* 1000;
    az = az .* 1000;

    %Integration into velocity
    [vx, vy, vz] = integral(ax, ay, az, datasize(1), dt);


    %Integration into displacement
    [dx, dy, dz] = integral(vx, vy, vz, datasize(1)+1, dt);

    %plot velocity
    figure;
    subplot(3,1,1);
    plot(vx);
    xlabel('sample')
    ylabel('cm/s')
    title('X-Velocity')
    %axis([-inf, inf, -0.01, 0.01]);
    subplot(3,1,2)
    plot(vy);
    xlabel('sample')
    ylabel('cm/s')
    title('Y-Velocity')
    %axis([-inf, inf, -0.01, 0.01]);
    subplot(3,1,3)
    plot(vz);
    xlabel('sample')
    ylabel('cm/s^2')
    title('Z-Velocity')
    %axis([-inf, inf, -0.01, 0.01]);
    %return;


    figure;
    plot(dx, dy,'*')
    grid on;
    %axis([-5, 5, -5, 5]);
    figure;
    plot3(dx, dy, dz, '*')

end