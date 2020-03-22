clear; clc;

rawdata = readtable('./pair_data/DTW_h1_o1_80.csv');
%load data
EPC = split(string(rawdata.x___EPC_(:)));
%EPC = split(string(rawdata.EPC(:)));
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
alpha = 0.3;
beta = 4;
gamma = 30;
centerfreq = 925.0;
humID = {'BDEF'};
objID = {'BD75'};
%humID = {'CC4D'};
%objID = {'CC60'};
humSIZE = 1;
objSIZE = 1;
OUTPUT = false;
FIGURE = true;
%humSIZE = size(humID);
%humSIZE = humSIZE(2);
%objSIZE = size(objID);
%objSIZE = objSIZE(2);

%Calibration to center freq
phasecor = (phase ./ freq) .* centerfreq;

%Add blank by min delta T
[rawEPC, rawphase, rawrssi, rawSIZE] = add_blank(time, EPC, phasecor, rssi, rawdataSIZE);

%Unwrapping phase and filling the blank by interpolation
[hum_phase, hum_rssi ,hum_firstT, hum_endT, hum_idx] = fill_blank(rawEPC, rawphase, rawrssi, humID, humSIZE, rawSIZE);
[obj_phase, obj_rssi ,obj_firstT, obj_endT, obj_idx] = fill_blank(rawEPC, rawphase, rawrssi, objID, objSIZE, rawSIZE);

%Calculate the subset of D
[delta_T, delta_phase, delta_rssi, dtw_phase, dtw_rssi] = subset_D(humSIZE, objSIZE, hum_phase, obj_phase, hum_rssi, obj_rssi, hum_firstT, obj_firstT, hum_endT, obj_endT);

%D = alpha * D_T + beta * D_phase + gamma * D_rssi
deltaD = delta_T .* alpha + dtw_phase .* beta + dtw_rssi .* gamma

%Pairing result
fprintf('Pairing result:\n');
for i = 1:humSIZE
    minD = min(deltaD(:));
    [row,col] = find(deltaD==minD);
    fprintf('    hum %d <==> obj %d\n', row, col);
    deltaD(row, :) = Inf;
    deltaD(:, col) = Inf;
end

%Plot
if FIGURE
    figure;
    for i = 1:humSIZE
        plot(hum_phase(:, i), 'DisplayName', ['hum ',num2str(i)]);
        hold on;
        idx_n = find(hum_idx(:,i));
        plot(idx_n, hum_phase(idx_n, i),'*', 'DisplayName', ['hum ',num2str(i)]);
    end
    for i = 1:objSIZE
        plot(obj_phase(:, i), 'DisplayName', ['obj ',num2str(i)]);
        idx_n = find(obj_idx(:,i));
        plot(idx_n, obj_phase(idx_n, i),'*', 'DisplayName', ['obj ',num2str(i)]);
    end
    hold off;
    legend;
    xlabel('Sample')
    ylabel('Phase(^o)')
    title('Phase');

    figure;
    for i = 1:humSIZE
        plot(hum_rssi(:, i), 'DisplayName', ['hum ',num2str(i)]);
        hold on;
    end
    for i = 1:objSIZE
        plot(obj_rssi(:, i), 'DisplayName', ['obj ',num2str(i)]);
    end
    hold off;
    legend;
    xlabel('Sample')
    ylabel('rssi(dB)')
    title('RSSI');
end

%output data 150 samples of phase and rssi 
if OUTPUT
    collect_sec = 8.0;
    [hum_name, hum_phasedata, hum_rssidata] = output_ML_data(collect_sec, rawSIZE, humSIZE, hum_firstT, hum_endT, hum_phase, hum_rssi, 'hum');
    [obj_name, obj_phasedata, obj_rssidata] = output_ML_data(collect_sec, rawSIZE, objSIZE, obj_firstT, obj_endT, obj_phase, obj_rssi, 'obj');

    %write data file
    csvwrite('./ML_realdata/hum_phase.csv', hum_name);
    dlmwrite('./ML_realdata/hum_phase.csv', hum_phasedata, '-append');
    csvwrite('./ML_realdata/hum_rssi.csv', hum_name);
    dlmwrite('./ML_realdata/hum_rssi.csv', hum_rssidata, '-append');
    
    csvwrite('./ML_realdata/obj_phase.csv', obj_name);
    dlmwrite('./ML_realdata/obj_phase.csv', obj_phasedata, '-append');
    csvwrite('./ML_realdata/obj_rssi.csv', obj_name);
    dlmwrite('./ML_realdata/obj_rssi.csv', obj_rssidata, '-append');
end
