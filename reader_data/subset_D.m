function [delta_T, delta_phase, delta_rssi, dtw_phase, dtw_rssi] = subset_D(humSIZE, objSIZE, hum_phase, obj_phase, hum_rssi, obj_rssi, hum_firstT, obj_firstT, hum_endT, obj_endT);
    delta_T = zeros(humSIZE, objSIZE);
    delta_phase = zeros(humSIZE, objSIZE);
    delta_rssi = zeros(humSIZE, objSIZE);
    dtw_phase = zeros(humSIZE, objSIZE);
    dtw_rssi = zeros(humSIZE, objSIZE);

    for i = 1:humSIZE
        for j = 1:objSIZE
            %D_T
            delta_T(i, j) = abs(hum_firstT(i) - obj_firstT(j)) +  abs(hum_endT(i) - obj_endT(j));
            s_first = max(hum_firstT(i), obj_firstT(j));
            s_end = min(hum_endT(i), obj_endT(j));
            if (s_first > s_end)  %two seq don't overlap
                delta_phase(i, j) = inf;
                delta_rssi(i, j) = inf;
            else
                for k = s_first:s_end - 1 %D_phase
                    dif_hum = hum_phase(k + 1, i) - hum_phase(k, i);
                    dif_obj = obj_phase(k + 1, j) - obj_phase(k, j);
                    delta_phase(i, j) = delta_phase(i, j) + abs(dif_hum - dif_obj);
                end
                for k = s_first:s_end %D_rssi
                    delta_rssi(i, j) = delta_rssi(i, j) + abs(hum_rssi(k, i) - obj_rssi(k, j));
                end
                delta_phase(i, j) = delta_phase(i, j) / (s_end - s_first);
                delta_rssi(i, j) = delta_rssi(i, j) / (s_end - s_first + 1);

                %%DTW_phase
                max_dif = max(hum_phase(s_first: s_end, i) - obj_phase(s_first: s_end, j));
                min_dif = min(hum_phase(s_first: s_end, i) - obj_phase(s_first: s_end, j));
                for k = min_dif:0.1:max_dif
                    dtw_p = dtw(hum_phase(s_first: s_end, i), obj_phase(s_first: s_end, j) + k);
                    if(k == min_dif)
                        min_dtw = dtw_p;
                    elseif(min_dtw > dtw_p)
                        min_dtw = dtw_p;
                    end
                end
                dtw_phase(i ,j) = min_dtw / (s_end - s_first + 1);
                
                %%DTW_rssi
                max_dif = max(hum_rssi(s_first: s_end, i) - obj_rssi(s_first: s_end, j));
                min_dif = min(hum_rssi(s_first: s_end, i) - obj_rssi(s_first: s_end, j));
                for k = min_dif:0.1:max_dif
                    dtw_p = dtw(hum_rssi(s_first: s_end, i), obj_rssi(s_first: s_end, j) + k);
                    if(k == min_dif)
                        min_dtw = dtw_p;
                    elseif(min_dtw > dtw_p)
                        min_dtw = dtw_p;
                    end
                end
                dtw_rssi(i ,j) = min_dtw / (s_end - s_first + 1);
            end
        end
    end
end