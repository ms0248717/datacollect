close all;
clear;

%Load data
line1 = importdata('./Trajectory/line/Documents/data1.csv');
line2 = importdata('./Trajectory/line/Documents 2/data1.csv');
line3 = importdata('./Trajectory/line/Documents 3/data1.csv');
line4 = importdata('./Trajectory/line/Documents 4/data1.csv');
line5 = importdata('./Trajectory/line/Documents 5/data1.csv');
lines = [line1 line2 line3 line4 line5];

shake1 = importdata('./Trajectory/shake/Documents/data.csv');
shake2 = importdata('./Trajectory/shake/Documents 2/data.csv');
shake3 = importdata('./Trajectory/shake/Documents 3/data.csv');
shake4 = importdata('./Trajectory/shake/Documents 4/data.csv');
shake5 = importdata('./Trajectory/shake/Documents 5/data.csv');
shakes = [shake1 shake2 shake3 shake4 shake5];

square1 = importdata('./Trajectory/square/Documents/data.csv');
square2 = importdata('./Trajectory/square/Documents 2/data.csv');
square3 = importdata('./Trajectory/square/Documents 3/data.csv');
square4 = importdata('./Trajectory/square/Documents 4/data.csv');
square5 = importdata('./Trajectory/square/Documents 5/data.csv');
squares = [square1 square2 square3 square4 square5];

circle1 = importdata('./Trajectory/circle/Documents/data.csv');
circle2 = importdata('./Trajectory/circle/Documents 2/data.csv');
circle3 = importdata('./Trajectory/circle/Documents 3/data.csv');
circle4 = importdata('./Trajectory/circle/Documents 4/data.csv');
circle5 = importdata('./Trajectory/circle/Documents 5/data.csv');
circles = [circle1 circle2 circle3 circle4 circle5];

%still1 = importdata('./Trajectory/still/Documents/data.csv');
%still = [still1 still1 still1 still1 still1];

motions = [lines shakes squares circles];
load('./reader_data/stillnoise.mat')

%train data
typesize = 4;
trainsize = 4000;
phase_power = 30;
rssi_power = 10;
name = [];
train_phasedata = [];
train_rssidata = [];
train_distancedata = [];
train_label = zeros(1, trainsize);
freq = ones(150, 1)*925.0;

for i=1:trainsize
    
    typerand = unidrnd(typesize);
    nrand = unidrnd(5);
    if typerand == 1
        speedrand = rand + 4.5;
    else
        speedrand = rand + 0.5;
    end
    rawdata = motions((typerand - 1) * 5 + nrand);
    [phase_o, RSSI_o] = gen_phase_rssi(rawdata, speedrand);
    [phase_o] = unwrapping(phase_o, 150); 
    %if typerand == 5
    %    phase = phase_o + stillnoise(:,unidrnd(10));
    %else
    phase = awgn(phase_o, phase_power);
    %phase = phase_o;
    %end
    RSSI = awgn(RSSI_o, rssi_power);
    RSSI = round(RSSI ./ 0.5) .* 0.5;
    [phase] = phase_cor(phase); 
    [distance] = distance_cal(freq, phase, 150);
    train_label(i) = typerand - 1;
    train_phasedata = [train_phasedata phase];
    train_rssidata = [train_rssidata RSSI];
    train_distancedata = [train_distancedata distance];
    name = [name i];
    
end
%r = randperm(trainsize);
%r = 1:trainsize;
%train_label_r = train_label(r); 
%train_phasedata_r = train_phasedata(:,r);
%train_rssidata_r = train_rssidata(:,r);
%train_distancedata_r = train_distancedata(:,r);
%
%{
figure;
plot(phase_o);
hold on;
plot(phase,'*');
hold off;
figure;
plot(RSSI_o);
hold on;
plot(RSSI,'*');
figure;
plot(distance);
return;
%}


%write train data file
csvwrite('./ML_data/train_label_nr.csv', name);
dlmwrite('./ML_data/train_label_nr.csv', train_label, '-append');
csvwrite('./ML_data/train_phase_nr.csv', name);
dlmwrite('./ML_data/train_phase_nr.csv', train_phasedata, '-append');
csvwrite('./ML_data/train_rssi_nr.csv', name);
dlmwrite('./ML_data/train_rssi_nr.csv', train_rssidata, '-append');
csvwrite('./ML_data/train_distance_nr.csv', name);
dlmwrite('./ML_data/train_distance_nr.csv', train_distancedata, '-append');

%test data
testsize = 1000;
name = [];
test_phasedata = [];
test_rssidata = [];
test_distancedata = [];
test_label = zeros(1, testsize);
for i=1:testsize
    
    typerand = unidrnd(typesize);
    nrand = unidrnd(5);
    if typerand == 1
        speedrand = rand + 4.5;
    else
        speedrand = rand + 0.5;
    end
    rawdata = motions((typerand - 1) * 5 + nrand);
    [phase_o, RSSI_o] = gen_phase_rssi(rawdata, speedrand);
    [phase_o] = unwrapping(phase_o, 150); 
    %if typerand == 5
    %    phase = phase_o + stillnoise(:,unidrnd(10));
    %else
    phase = awgn(phase_o, phase_power);
    %phase = phase_o;
    %end
    RSSI = awgn(RSSI_o, rssi_power);
    RSSI = round(RSSI ./ 0.5) .* 0.5;
    [phase] = phase_cor(phase); 
    [distance] = distance_cal(freq, phase, 150);
    test_label(i) = typerand - 1;
    test_phasedata = [test_phasedata phase];
    test_rssidata = [test_rssidata RSSI];
    test_distancedata = [test_distancedata distance];
    name = [name i];
end


%write test data file
csvwrite('./ML_data/test_label_nr.csv', name);
dlmwrite('./ML_data/test_label_nr.csv', test_label, '-append');
csvwrite('./ML_data/test_phase_nr.csv', name);
dlmwrite('./ML_data/test_phase_nr.csv', test_phasedata, '-append');
csvwrite('./ML_data/test_rssi_nr.csv', name);
dlmwrite('./ML_data/test_rssi_nr.csv', test_rssidata, '-append');
csvwrite('./ML_data/test_distance_nr.csv', name);
dlmwrite('./ML_data/test_distance_nr.csv', test_distancedata, '-append');





