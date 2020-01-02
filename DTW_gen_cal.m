close all;
clear;
label = importdata('./ML_data/train_label_DTW.csv');
phase = importdata('./ML_data/train_phase_DTW.csv');
rssi = importdata('./ML_data/train_rssi_DTW.csv');

label = label(2, :);
phase = phase(2:end, :);
rssi = rssi(2:end, :);
rawsize = size(label, 2);

LABELS = ["line","shake","square","circle","still"];
for lab = 1:5
    result = zeros(1, 5);
    for num = 1:20
        namephase = strcat('./reader_data/ML_realdata/phase_',LABELS(lab) ,'_0_50_', num2str(num), '.csv');
        namerssi = strcat('./reader_data/ML_realdata/rssi_',LABELS(lab),'_0_50_', num2str(num), '.csv');
        outputphase = importdata(namephase);
        outputrssi = importdata(namerssi);
        delta_phase = dtw(outputphase(2:end), phase(:, 1));
        delta_rssi = dtw(outputrssi(2:end), rssi(:, 1));
        min_delta = delta_phase + delta_rssi;
        min_label = label(1);
        for i = 2:1000
            delta_phase = dtw(outputphase(2:end), phase(:, i));
            delta_rssi = dtw(outputrssi(2:end), rssi(:, i));
            if (delta_phase + delta_rssi < min_delta)
                min_delta = delta_phase + delta_rssi;
                min_label = label(i);
            end
        end
        result(min_label + 1) = result(min_label + 1) + 1; 
    end
    result
end