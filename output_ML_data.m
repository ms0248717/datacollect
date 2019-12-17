function [name, phasedata, rssidata] = output_ML_data(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, strn);
    name = [];
    phasedata = [];
    rssidata = [];
    take_sec = 5.0;
    outputSIZE = 150;
    sampleSIZE = round((rawSIZE * take_sec / collect_sec) / outputSIZE);
    takeSIZE = sampleSIZE * outputSIZE;
    V = zeros(1, rawSIZE-takeSIZE);
    for i = 1:SIZE
        if (endT(i) - firstT(i) > takeSIZE)
            phase_take = phase(endT(i) - takeSIZE + 1: endT(i), i);
            phase_take = mean(reshape(phase_take, sampleSIZE, []));
            [output_phase] = unwrapping(phase_take', 150);
            rssi_take = rssi(endT(i) - takeSIZE + 1: endT(i), i);
            rssi_take = mean(reshape(rssi_take, sampleSIZE, []));
            RSSI = round(rssi_take' ./ 0.5) .* 0.5;
            output_rssi = RSSI;
            phasedata = [phasedata output_phase];
            rssidata = [rssidata output_rssi];
            name = [name i];
            %figure;
            %plot(output_phase, '*');
            %figure;
            %plot(output_rssi, 'o');
            
            %var_cal
            for j=firstT(i):endT(i)-takeSIZE
                V(j) = var(phase(j:j+takeSIZE, i));
            end
        else
            fprintf('%s %d dont have enough data.\n',strn, i);
        end
    end
end