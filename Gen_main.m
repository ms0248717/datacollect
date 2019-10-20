close all;
clear;

%Load data
right1 = importdata('./Trajectory/right/Documents/data.csv');
right2 = importdata('./Trajectory/right/Documents 2/data.csv');
right3 = importdata('./Trajectory/right/Documents 3/data.csv');
right4 = importdata('./Trajectory/right/Documents 4/data.csv');
right5 = importdata('./Trajectory/right/Documents 5/data.csv');
rights = [right1 right2 right3 right4 right5];

shake1 = importdata('./Trajectory/shake/Documents/data.csv');
shake2 = importdata('./Trajectory/shake/Documents 2/data.csv');
shake3 = importdata('./Trajectory/shake/Documents 3/data.csv');
shake4 = importdata('./Trajectory/shake/Documents 4/data.csv');
shake5 = importdata('./Trajectory/shake/Documents 5/data.csv');
shakes = [shake1 shake2 shake3 shake4 shake5];

motions = [rights shakes];

%train data
typesize = 2;
trainsize = 4000;
name = [];
train_phasedata = [];
train_rssidata = [];
train_label = zeros(1, trainsize);
for i=1:trainsize
    
    typerand = unidrnd(typesize);
    nrand = unidrnd(5);
    speedrand = rand*1 + 0.5;
    speedrand = 1;
    rawdata = motions((typerand - 1) * 5 + nrand);
    [phase, RSSI] = gen_phase_rssi(rawdata, speedrand);
    
    train_label(i) = typerand - 1;
    train_phasedata = [train_phasedata phase];
    train_rssidata = [train_rssidata RSSI];
    name = [name i];
    
end

%write train data file
csvwrite('./ML_data/train_label.csv', name);
dlmwrite('./ML_data/train_label.csv', train_label, '-append');
csvwrite('./ML_data/train_phase.csv', name);
dlmwrite('./ML_data/train_phase.csv', train_phasedata, '-append');
csvwrite('./ML_data/train_rssi.csv', name);
dlmwrite('./ML_data/train_rssi.csv', train_rssidata, '-append');

%test data
testsize = 1000;
name = [];
test_phasedata = [];
test_rssidata = [];
test_label = zeros(1, testsize);
for i=1:testsize
    
    typerand = unidrnd(typesize);
    nrand = unidrnd(5);
    speedrand = rand*1 + 0.5;
    speedrand = 1;
    rawdata = motions((typerand - 1) * 5 + nrand);
    [phase, RSSI] = gen_phase_rssi(rawdata, speedrand);
    
    test_label(i) = typerand - 1;
    test_phasedata = [test_phasedata phase];
    test_rssidata = [test_rssidata RSSI];
    name = [name i];
end



%write test data file
csvwrite('./ML_data/test_label.csv', name);
dlmwrite('./ML_data/test_label.csv', test_label, '-append');
csvwrite('./ML_data/test_phase.csv', name);
dlmwrite('./ML_data/test_phase.csv', test_phasedata, '-append');
csvwrite('./ML_data/test_rssi.csv', name);
dlmwrite('./ML_data/test_rssi.csv', test_rssidata, '-append');





