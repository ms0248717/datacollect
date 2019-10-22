close all;
clear;

rawdata = importdata('./data.csv');

ax = rawdata.data(:,1);
ay = rawdata.data(:,2);
az = rawdata.data(:,3);

%Define parameters
datacollectfreq = 30;
noiserange = 0.015;
ConvergeRate = 0.8;
SpeedRate = 1.0;

ReaderPosition = [0 0 3];
%phaseshift = rand * 2 * pi;
C = 3 * 10^8;
freq = 925 * 10^6;
lambda = C / freq;


%Acceleration to Position
[dx, dy, dz] = CalibrationPosition(ax, ay, az, datacollectfreq, noiserange, ConvergeRate, SpeedRate);
%[dx, dy, dz] = Position(ax, ay, az, datacollectfreq);

figure;
plot(dx, dy,'*')
grid on;
axis([-0.3, 0.3, -0.3, 0.3]);
figure;
plot3(dx, dy, dz, '*')