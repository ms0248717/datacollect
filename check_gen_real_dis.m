close all;
clear;
still1 = importdata('./Trajectory/still/Documents/data.csv');
line1 = importdata('./Trajectory/line/Documents/data.csv');
shake1 = importdata('./Trajectory/shake/Documents/data.csv');
square1 = importdata('./Trajectory/square/Documents/data.csv');
circle1 = importdata('./Trajectory/circle/Documents/data.csv');
load('./reader_data/stillnoise.mat')


phase_power = 45;
rssi_power = 25;
freq = ones(150, 1)*925.0;


speedrand = rand*10 + 1.0;
rawdata = line1;
[phase_o, RSSI_o] = gen_phase_rssi(rawdata, speedrand);
phase_gen = awgn(phase_o, phase_power);
%phase_gen = phase_o;
RSSI_gen = awgn(RSSI_o, rssi_power);
RSSI_gen = round(RSSI_gen ./ 0.5) .* 0.5;
%[phase_gen] = unwrapping(phase_gen, 150); 
[phase_gen] = phase_cor(phase_gen); 
%phase_gen = phase_gen + stillnoise(:,unidrnd(10));
[distance_gen] = distance_cal(freq, phase_gen, 150);


rawdata = readtable('./reader_data/data/line_0_50_12.csv');

%load data
%EPC = split(string(rawdata.x___EPC_(:)));
EPC = split(string(rawdata.EPC(:)));
time = str2double(rawdata.Timestamp(:));
freq = str2double(rawdata.ChannelInMhz(:));
rssi = str2double(rawdata.PeakRssiInDbm(:));
phase_o = str2double(rawdata.PhaseAngleInRadians(:));

time = time - time(1);
%%EPC = split(EPC);
EPC = EPC(:,6);
rawdataSIZE = size(EPC);
rawdataSIZE = rawdataSIZE(1);

%Parameter definition
centerfreq = 925.0;
ID = {'BDEF'};
SIZE = size(ID);
SIZE = SIZE(2);
OUTPUT = true;
FIGURE = false;

%Calibration to center freq
%phase = unwrapping(phase, SIZE);
phasecor = (phase_o ./ freq) .* centerfreq;
%phasecor = fixwrapping(freq, phase, rawdataSIZE);
[distance_c] = distance_cal(freq, phase_o, rawdataSIZE);


%Add blank by min delta T
[rawEPC, rawphase, rawrssi, rawdistance,rawSIZE] = add_blank_dis(time, EPC, phasecor, rssi, distance_c, rawdataSIZE);

%Unwrapping phase and filling the blank by interpolation
[phase, rssi, distance, firstT, endT, idx] = fill_blank_dis(rawEPC, rawphase, rawrssi, rawdistance, ID, SIZE, rawSIZE);
collect_sec = 8.0;
[name, phasedata, rssidata, distancedata] = output_ML_data_dis(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, distance, 'tag');

%figure;
%plot(phase_gen, '*');
%hold on;
%plot(phasedata,'o');
%xlabel('Sample')
%ylabel('Phase(^o)')
%title('Phase');
%hold off;
figure;
plot(RSSI_gen, '*');
hold on;
plot(rssidata,'o');
xlabel('Sample')
ylabel('RSSI(dB)')
title('RSSI');
figure;
plot(distance_gen, '*');
hold on;
plot(distancedata,'o');
xlabel('Sample')
ylabel('Distance(m)')
title('Distance');
