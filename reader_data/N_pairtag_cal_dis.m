clear; clc;

for num = 1:10
    rawdata = readtable(['./circle_0_50_', num2str(num), '.csv']);
    outputphase = ['./ML_realdata/phase_circle_0_50_', num2str(num), '.csv'];
    outputrssi = ['./ML_realdata/rssi_circle_0_50_', num2str(num), '.csv'];
    outputdistance = ['./ML_realdata/distance_circle_0_50_', num2str(num), '.csv'];

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
    %phasecor = fixwrapping(freq, phase, rawdataSIZE);
    
    [distance_c] = distance_cal(freq, phase, rawdataSIZE);

    %Add blank by min delta T
    [rawEPC, rawphase, rawrssi, rawdistance,rawSIZE] = add_blank_dis(time, EPC, phasecor, rssi, distance_c, rawdataSIZE);

    %Unwrapping phase and filling the blank by interpolation
    [phase, rssi, distance, firstT, endT, idx] = fill_blank_dis(rawEPC, rawphase, rawrssi, rawdistance, ID, SIZE, rawSIZE);

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
        [name, phasedata, rssidata, distancedata] = output_ML_data_dis(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, distance, 'tag');

        %write data file
        csvwrite(outputphase, name);
        dlmwrite(outputphase, phasedata, '-append');
        csvwrite(outputrssi, name);
        dlmwrite(outputrssi, rssidata, '-append');
        csvwrite(outputdistance, name);
        dlmwrite(outputdistance, distancedata, '-append');
    end
end
