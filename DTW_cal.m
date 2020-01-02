close all;
clear;

LABELS = ["line","shake","square","circle","still"];
phase = [];
rssi = [];
label = [];
for lab = 1:5
    result = zeros(1, 5);
    for num = 1:5
        namephase = strcat('./reader_data/ML_realdata/phase_',LABELS(lab) ,'_0_50_', num2str(num), '.csv');
        namerssi = strcat('./reader_data/ML_realdata/rssi_',LABELS(lab),'_0_50_', num2str(num), '.csv');
        outputphase = importdata(namephase);
        outputrssi = importdata(namerssi);
        phase = [phase outputphase(2:end)];
        rssi = [rssi outputrssi(2:end)];
        label = [label lab];
    end
end
for lab = 1:5
    result = zeros(1, 5);
    for num = 6:20
        namephase = strcat('./reader_data/ML_realdata/phase_',LABELS(lab) ,'_0_50_', num2str(num), '.csv');
        namerssi = strcat('./reader_data/ML_realdata/rssi_',LABELS(lab),'_0_50_', num2str(num), '.csv');
        outputphase = importdata(namephase);
        outputrssi = importdata(namerssi);
        delta_phase = dtw(outputphase(2:end), phase(:, 1));
        delta_rssi = dtw(outputrssi(2:end), rssi(:, 1));
        min_delta = delta_phase + delta_rssi;
        min_label = label(1);
        for i = 2:25
            delta_phase = dtw(outputphase(2:end), phase(:, i));
            delta_rssi = dtw(outputrssi(2:end), rssi(:, i));
            if (delta_phase + delta_rssi < min_delta)
                min_delta = delta_phase + delta_rssi;
                min_label = label(i);
            end
        end
        result(min_label) = result(min_label) + 1; 
    end
    result
end