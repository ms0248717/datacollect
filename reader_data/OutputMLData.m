function [name, phasedata, rssidata] = OutputMLData(collect_sec, rawSIZE, humSIZE, hum_firstT, hum_endT, hum_phase, hum_rssi, objSIZE, obj_firstT, obj_endT, obj_phase, obj_rssi);
    name = [];
    phasedata = [];
    rssidata = [];
    take_sec = 5.0;
    outputSIZE = 150;
    namei = 1;
    sampleSIZE = round((rawSIZE * take_sec / collect_sec) / outputSIZE);
    takeSIZE = sampleSIZE * outputSIZE;
    for i = 1:humSIZE
        if (hum_endT(i) - hum_firstT(i) > takeSIZE)
            hum_phase_take = hum_phase(hum_endT(i) - takeSIZE + 1: hum_endT(i), i);
            hum_phase_take = mean(reshape(hum_phase_take, sampleSIZE, []));
            [output_phase] = phase_cor(hum_phase_take');
            hum_rssi_take = hum_rssi(hum_endT(i) - takeSIZE + 1: hum_endT(i), i);
            hum_rssi_take = mean(reshape(hum_rssi_take, sampleSIZE, []));
            output_rssi = hum_rssi_take';
            phasedata = [phasedata output_phase];
            rssidata = [rssidata output_rssi];
            name = [name namei];
            namei = namei + 1;
        end
    end
    
    for i = 1:objSIZE
       if (obj_endT(i) - obj_firstT(i) > takeSIZE)
            obj_phase_take = obj_phase(obj_endT(i) - takeSIZE + 1: obj_endT(i), i);
            obj_phase_take = mean(reshape(obj_phase_take, sampleSIZE, []));
            [output_phase] = phase_cor(obj_phase_take');
            obj_rssi_take = obj_rssi(obj_endT(i) - takeSIZE + 1: obj_endT(i), i);
            obj_rssi_take = mean(reshape(obj_rssi_take, sampleSIZE, []));
            output_rssi = obj_rssi_take';
            phasedata = [phasedata output_phase];
            rssidata = [rssidata output_rssi];
            name = [name namei];
            namei = namei + 1;
        end
    end
end
