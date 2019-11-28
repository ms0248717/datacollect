still1 = importdata('./Trajectory/still/Documents/data.csv');
right1 = importdata('./Trajectory/right/Documents/data.csv');
shake1 = importdata('./Trajectory/shake/Documents/data.csv');
square1 = importdata('./Trajectory/square/Documents/data.csv');
circle1 = importdata('./Trajectory/circle/Documents/data.csv');

phase_power = 30;
rssi_power = 25;

speedrand = rand*10 + 1.0;
rawdata = shake1;
[phase_o, RSSI_o] = gen_phase_rssi(rawdata, speedrand);
phase_gen = awgn(phase_o, phase_power);
RSSI_gen = awgn(RSSI_o, rssi_power);
RSSI_gen = round(RSSI_gen ./ 0.5) .* 0.5;
[phase_gen] = phase_cor(phase_gen); 

rawdata = readtable('./reader_data/shake_0_50_3.csv');

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
phasecor = (phase ./ freq) .* centerfreq;
phasecor = fixwrapping(freq, phase, rawdataSIZE);

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
