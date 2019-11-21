clear; clc;

rawdata = readtable('./square_2.csv');

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
centerfreq = 925.0;
ID = {'BD9E', 'BDEF'};
SIZE = size(ID);
SIZE = SIZE(2);
OUTPUT = true;
FIGURE = false;

%Calibration to center freq
phasecor = (phase ./ freq) .* centerfreq;

%Add blank by min delta T
[rawEPC, rawphase, rawrssi, rawSIZE] = add_blank(time, EPC, phasecor, rssi, rawdataSIZE);

%Unwrapping phase and filling the blank by interpolation
[phase, rssi ,firstT, endT, idx] = fill_blank(rawEPC, rawphase, rawrssi, ID, SIZE, rawSIZE);

%Plot
if FIGURE
    figure;
    for i = 1:SIZE
        plot(phase(:, i), 'DisplayName', ['tag ',num2str(i)]);
        hold on;
        idx_n = find(idx(:,i));
        plot(idx_n, phase(idx_n, i),'*', 'DisplayName', ['tag ',num2str(i)]);
    end
    hold off;
    legend;
    xlabel('Sample')
    ylabel('Phase(^o)')
    title('Phase');

    figure;
    for i = 1:SIZE
        plot(rssi(:, i), 'DisplayName', ['tag ',num2str(i)]);
        hold on;
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
    [name, phasedata, rssidata] = output_ML_data(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, 'tag');
    
    %write data file
    csvwrite('./ML_realdata/phase.csv', name);
    dlmwrite('./ML_realdata/phase.csv', phasedata, '-append');
    csvwrite('./ML_realdata/rssi.csv', name);
    dlmwrite('./ML_realdata/rssi.csv', rssidata, '-append');
end
