clear; clc;
LABELS = {'line','shake','square','circle'};
DIS = [50, 100, 150];
outputfile1 = 'reader_phase.mat';
outputfile2 = 'reader_rssi.mat';
outputfile3 = 'reader_distance.mat';
reader_distance = [];
reader_phase = [];
reader_rssi = [];
for lab = 1:4
    for dis = 1:3
        for num = 6:15
            rawdis = readtable(['./ML_realdata/distance_', char(LABELS(lab)),'_0_',num2str(DIS(dis)),'_', num2str(num), '.csv']);
            rawphase = readtable(['./ML_realdata/phase_', char(LABELS(lab)),'_0_',num2str(DIS(dis)),'_', num2str(num), '.csv']);
            rawrssi = readtable(['./ML_realdata/rssi_', char(LABELS(lab)),'_0_',num2str(DIS(dis)),'_', num2str(num), '.csv']);
            Distance = rawdis.x1(:);
            Phase = rawphase.x1(:);
            Rssi = rawrssi.x1(:);
            reader_distance = [reader_distance Distance];
            reader_phase = [reader_phase Phase];
            reader_rssi = [reader_rssi Rssi];
        end
    end
end

save(outputfile1, 'reader_distance');
save(outputfile2, 'reader_phase');
save(outputfile3, 'reader_rssi');