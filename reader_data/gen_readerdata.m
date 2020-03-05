clear; clc;
LABELS = {'line','shake','square','circle'};
DIS = [50, 100, 150];
ANG = [0, 30, 60];
outputfile1 = 'reader_phase.mat';
outputfile2 = 'reader_rssi.mat';
outputfile3 = 'reader_distance.mat';
reader_distance = [];
reader_phase = [];
reader_rssi = [];
for lab = 1:4
    for ang = 1:3
        for dis = 1:3
            for num = 1:2
                rawdis = readtable(['./ML_realdata/distance_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_90_5_', num2str(num), '.csv']);
                rawphase = readtable(['./ML_realdata/phase_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_90_5_', num2str(num), '.csv']);
                rawrssi = readtable(['./ML_realdata/rssi_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_90_5_', num2str(num), '.csv']);
                Distance = table2array(rawdis);
                Phase = table2array(rawphase);
                Rssi = table2array(rawrssi);
                reader_distance = [reader_distance Distance];
                reader_phase = [reader_phase Phase];
                reader_rssi = [reader_rssi Rssi];
                rawdis = readtable(['./ML_realdata/distance_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_0_5_', num2str(num), '.csv']);
                rawphase = readtable(['./ML_realdata/phase_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_0_5_', num2str(num), '.csv']);
                rawrssi = readtable(['./ML_realdata/rssi_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_0_5_', num2str(num), '.csv']);
                Distance = table2array(rawdis);
                Phase = table2array(rawphase);
                Rssi = table2array(rawrssi);
                reader_distance = [reader_distance Distance];
                reader_phase = [reader_phase Phase];
                reader_rssi = [reader_rssi Rssi];
            end
        end
    end
end

save(outputfile1, 'reader_distance');
save(outputfile2, 'reader_phase');
save(outputfile3, 'reader_rssi');