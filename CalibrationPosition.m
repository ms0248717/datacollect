function [dx, dy, dz] = CalibrationPosition(ax, ay, az, freq, noiserange, ConvergeRate)

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

    %Remove small noise
    datasize = size(ax);
    for i = 1:datasize(1)
        if abs(ax(i)) < noiserange
            ax(i) = 0;
        end
        if abs(ay(i)) < noiserange
            ay(i) = 0;
        end
        if abs(az(i)) < noiserange
            az(i) = 0;
        end
    end

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

    %Convert to m
    ax = ax .* 9.8;
    ay = ay .* 9.8;
    az = az .* 9.8;

    %Integration into velocity
    [vx, vy, vz] = integral(ax, ay, az, datasize(1), dt);

    %Converge if acceleration == 0
    for i = 1:datasize(1)-5
        mx = 0;
        my = 0;
        mz = 0;
        for j = 1:5
            mx = mx + ax(i + j - 1);
            my = my + ay(i + j - 1);
            mz = mz + az(i + j - 1);
        end
        if mx == 0
            vx(i+6) = vx(i+5) * ConvergeRate;
        end
        if my == 0
            vy(i+6) = vy(i+5) * ConvergeRate;
        end
        if mz == 0
            vz(i+6) = vz(i+5) * ConvergeRate;
        end
    end

    %Integration into displacement
    [dx, dy, dz] = integral(vx, vy, vz, datasize(1)+1, dt);

    %plot velocity
    figure;
    subplot(3,1,1);
    plot(vx);
    xlabel('sample')
    ylabel('m/s')
    title('X-Velocity')
    %axis([-inf, inf, -0.01, 0.01]);
    subplot(3,1,2)
    plot(vy);
    xlabel('sample')
    ylabel('m/s')
    title('Y-Velocity')
    %axis([-inf, inf, -0.01, 0.01]);
    subplot(3,1,3)
    plot(vz);
    xlabel('sample')
    ylabel('m/s^2')
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