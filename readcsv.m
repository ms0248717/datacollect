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
ConvergeRate = 0.7;

ReaderPosition = [0 0 300];
%phaseshift = rand * 2 * pi;
C = 3 * 10^8;
freq = 925 * 10^6;
lambda = C / freq * 100;


%Acceleration to Position
[dx, dy, dz] = CalibrationPosition(ax, ay, az, datacollectfreq, noiserange, ConvergeRate);
%[dx, dy, dz] = Position(ax, ay, az, datacollectfreq);

%Rotation data
randR = rand * 360;
xR = dx*cosd(randR) + dy*sind(randR);
yR = -dx*sind(randR) + dy*cosd(randR);

%Translation data
randTx = 200 - (rand * 400);
randTy = 200 - (rand * 400);
randTz = 15 - (rand * 30);
xT = xR + randTx;
yT = yR + randTy;
zT = dz + randTz + 150;
figure;
plot3(xT, yT, zT, '*')
hold on;
plot3(0, 0, 300, 'o');
hold off;

%Position to Phase
datasize = size(xT);
phase = zeros(datasize(1), 1);
for i=1:datasize(1)
    P_A = [xT(i) yT(i) zT(i)];
    length = dist(P_A, ReaderPosition');
    phase(i) = (mod(length, lambda)/ lambda) * 2 * pi;
end
figure;
plot(phase, '*')
grid on;
axis([-inf, inf, 0, 2*pi]);