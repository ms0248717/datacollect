function [name, phasedata, rssidata, distancedata] = output_ML_data_dis(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, distance, strn);
    name = [];
    phasedata = [];
    rssidata = [];
    distancedata = [];
    take_sec = 5.0;
    outputSIZE = 150;
    allN = 15;
    outputN = 5;
    sampleSIZE = round((rawSIZE * take_sec / collect_sec) / outputSIZE);
    takeSIZE = sampleSIZE * outputSIZE;
    V = zeros(1, rawSIZE-takeSIZE);
    for i = 1:SIZE
        dataSIZE = endT(i) - firstT(i);
        if (dataSIZE > takeSIZE) && (dataSIZE - takeSIZE > allN)
            step = floor((dataSIZE - takeSIZE) / allN);
            for j = 1:outputN
                startN = endT(i) - takeSIZE + 1 - ((j - 1) * step);
                endN = endT(i) - ((j - 1) * step);
                
                phase_take = phase(startN: endN, i);
                phase_take = mean(reshape(phase_take, sampleSIZE, []));
                [output_phase] = phase_cor(phase_take');
                
                rssi_take = rssi(startN: endN, i);
                rssi_take = mean(reshape(rssi_take, sampleSIZE, []));
                output_rssi = round(rssi_take' ./ 0.5) .* 0.5;
                
                distance_take = distance(startN: endN, i);
                distance_take = mean(reshape(distance_take, sampleSIZE, []));
                output_distance = distance_take';
                
                phasedata = [phasedata output_phase];
                rssidata = [rssidata output_rssi];
                distancedata = [distancedata output_distance];
                name = [name i];
                %figure;
                %plot(output_phase, '*');
                %figure;
                %plot(output_rssi, 'o');
                %figure;
                %plot(output_distance, 'o');
                %var_cal
                %for j=firstT(i):endT(i)-takeSIZE
                %    V(j) = var(phase(j:j+takeSIZE, i));
                %end
             end
        else
            fprintf('%s %d dont have enough data.\n',strn, i);
        end
    end
end
