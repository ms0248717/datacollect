function [name, phasedata, rssidata] = OutputMLData(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, strn);
    name = [];
    phasedata = [];
    rssidata = [];
    take_sec = 5.0;
    outputSIZE = 150;
    sampleSIZE = round((rawSIZE * take_sec / collect_sec) / outputSIZE);
    takeSIZE = sampleSIZE * outputSIZE;
    for i = 1:SIZE
        if (endT(i) - firstT(i) > takeSIZE)
            phase_take = phase(endT(i) - takeSIZE + 1: endT(i), i);
            phase_take = mean(reshape(phase_take, sampleSIZE, []));
            [output_phase] = phase_cor(phase_take');
            rssi_take = rssi(endT(i) - takeSIZE + 1: endT(i), i);
            rssi_take = mean(reshape(rssi_take, sampleSIZE, []));
            output_rssi = rssi_take';
            phasedata = [phasedata output_phase];
            rssidata = [rssidata output_rssi];
            name = [name i];
        else
            fprintf('%s %d dont have enough data.\n',strn, i);
        end
    end
end
