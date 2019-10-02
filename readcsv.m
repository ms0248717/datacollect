close all;
clear;

%Load data
rawdata = importdata('data.csv');
ax = rawdata.data(:,1);
ay = rawdata.data(:,2);
az = rawdata.data(:,3);

%Define parameters
datacollectfreq = 30;
noiserange = 0.015;
ConvergeRate = 1.0;


ReaderPosition = [0 0 3];
%phaseshift = rand * 2 * pi;
C = 3 * 10^8;
freq = 925 * 10^6;
lambda = C / freq;


%Acceleration to Position
[dx, dy, dz] = CalibrationPosition(ax, ay, az, datacollectfreq, noiserange, ConvergeRate);
%[dx, dy, dz] = Position(ax, ay, az, datacollectfreq);

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
figure;
plot3(xT, yT, zT, '*')
hold on;
plot3(0, 0, 3, 'o');
legend('Trajectory','Reader')
hold off;

%Position to Phase
datasize = size(xT);
P_A = [xT yT zT];
length = dist(P_A, ReaderPosition') * 2;
phase = (mod(length, lambda)/ lambda) * 2 * pi;
figure;
plot(phase, '*')
xlabel('Sample')
ylabel('Phase(^o)')
title('Theoretical Phase')
grid on;
axis([-inf, inf, 0, 2*pi]);

%Position to RSSI
RSSI = TheoreticalRSSI(length);
figure;
plot(RSSI, '*')
xlabel('Sample')
ylabel('RSSI(dB)')
title('Theoretical RSSI')

%Plot dist
figure;
plot(length, '*')
xlabel('Sample')
ylabel('Distance(m)')
title('Distance')