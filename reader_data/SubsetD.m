function [delta_T, delta_phase, delta_rssi] = SubsetD(humSIZE, objSIZE, hum_phase, obj_phase, hum_rssi, obj_rssi, hum_firstT, obj_firstT, hum_endT, obj_endT);
    delta_T = zeros(humSIZE, objSIZE);
    delta_phase = zeros(humSIZE, objSIZE);
    delta_rssi = zeros(humSIZE, objSIZE);

    for i = 1:humSIZE
        for j = 1:objSIZE
            delta_T(i, j) = abs(hum_firstT(i) - obj_firstT(j)) +  abs(hum_endT(i) - obj_endT(j));
            s_first = max(hum_firstT(i), obj_firstT(j));
            s_end = min(hum_endT(i), obj_endT(j));
            if (s_first > s_end)
                delta_phase(i, j) = inf;
                delta_rssi(i, j) = inf;
            else
                for k = s_first:s_end - 1
                    dif_hum = hum_phase(k + 1, i) - hum_phase(k, i);
                    dif_obj = obj_phase(k + 1, j) - obj_phase(k, j);
                    delta_phase(i, j) = delta_phase(i, j) + abs(dif_hum - dif_obj);
                end
                for k = s_first:s_end
                    delta_rssi(i, j) = delta_rssi(i, j) + abs(hum_rssi(k, i) - obj_rssi(k, j));
                end
            end
        end
    end
end