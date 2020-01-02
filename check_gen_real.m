still1 = importdata('./Trajectory/still/Documents/data.csv');
line1 = importdata('./Trajectory/line/Documents/data.csv');
shake1 = importdata('./Trajectory/shake/Documents/data.csv');
square1 = importdata('./Trajectory/square/Documents/data.csv');
circle1 = importdata('./Trajectory/circle/Documents/data.csv');
load('./reader_data/stillnoise.mat')


phase_power = 15;
rssi_power = 25;

speedrand = rand*10 + 1.0;
rawdata = square1;
[phase_o, RSSI_o] = gen_phase_rssi(rawdata, speedrand);
phase_gen = awgn(phase_o, phase_power);
RSSI_gen = awgn(RSSI_o, rssi_power);
RSSI_gen = round(RSSI_gen ./ 0.5) .* 0.5;
%[phase_gen] = unwrapping(phase_gen, 150); 
[phase_gen] = phase_cor(phase_gen); 
%phase_gen = phase_gen + stillnoise(:,unidrnd(10));
[distance_gen] = distance_cal(freq, phase, 150);


rawdata = readtable('./reader_data/data/circle_0_50_14.csv');

%load data
%EPC = split(string(rawdata.x___EPC_(:)));
EPC = split(string(rawdata.EPC(:)));
time = str2double(rawdata.Timestamp(:));
freq = str2double(rawdata.ChannelInMhz(:));
rssi = str2double(rawdata.PeakRssiInDbm(:));
phase = str2double(rawdata.PhaseAngleInRadians(:));

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
phasecor = (phase ./ freq) .* centerfreq;
%phasecor = fixwrapping(freq, phase, rawdataSIZE);

%Add blank by min delta T
[rawEPC, rawphase, rawrssi, rawSIZE] = add_blank(time, EPC, phasecor, rssi, rawdataSIZE);

%Unwrapping phase and filling the blank by interpolation
[phase, rssi ,firstT, endT, idx] = fill_blank(rawEPC, rawphase, rawrssi, ID, SIZE, rawSIZE);
collect_sec = 8.0;
[name, phasedata, rssidata] = output_ML_data(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, 'tag');

figure;
plot(phase_gen, '*');
hold on;
plot(phasedata,'o');
xlabel('Sample')
ylabel('Phase(^o)')
title('Phase');
hold off;
figure;
plot(RSSI_gen, '*');
hold on;
plot(rssidata,'o');
xlabel('Sample')
ylabel('RSSI(dB)')
title('RSSI');
