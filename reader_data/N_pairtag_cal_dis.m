clear; clc;
LABELS = {'line','shake','square','circle','still'};
DIS = [50, 100, 150];
ANG = [0, 30, 60];
for lab = 1:5
    for dis = 1:3
        for ang = 1:3
            for num = 1:20
                rawdata = readtable(['./data/', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_', num2str(num), '.csv']);
                outputphase = ['./ML_realdata/phase_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_n_', num2str(num), '.csv'];
                outputrssi = ['./ML_realdata/rssi_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_n_', num2str(num), '.csv'];
                outputdistance = ['./ML_realdata/distance_', char(LABELS(lab)),'_',num2str(ANG(ang)),'_',num2str(DIS(dis)),'_n_', num2str(num), '.csv'];

                %load data
                %EPC = split(string(rawdata.x___EPC_(:)));
                EPC = split(string(rawdata.EPC(:)));
                time = str2double(rawdata.Timestamp(:));
                freq = str2double(rawdata.ChannelInMhz(:));
                rssi = str2double(rawdata.PeakRssiInDbm(:));
                phase_o = str2double(rawdata.PhaseAngleInRadians(:));

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
                phasecor = (phase_o ./ freq) .* centerfreq;
                %phasecor = fixwrapping(freq, phase, rawdataSIZE);

                [distance_c] = distance_cal(freq, phase_o, rawdataSIZE);
                %figure;
                %plot(distance_c)

                %Add blank by min delta T
                [rawEPC, rawphase, rawrssi, rawdistance,rawSIZE] = add_blank_dis(time, EPC, phasecor, rssi, distance_c, rawdataSIZE);

                %Unwrapping phase and filling the blank by interpolation
                [phase, rssi, distance, firstT, endT, idx] = fill_blank_dis(rawEPC, rawphase, rawrssi, rawdistance, ID, SIZE, rawSIZE);

                %Plot
                if FIGURE
                    %{
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
                    %}

                    figure;
                    for i = 1:SIZE
                        plot(distance(:, i), 'DisplayName', ['tag ',num2str(i)]);
                        hold on;
                    end
                    hold off;
                    legend;
                    xlabel('Sample')
                    ylabel('Distance(m)')
                    title('Distance');
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
        end
    end
end