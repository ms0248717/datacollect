function [phase, rssi ,firstT, endT, idx] = FillBlank(rawEPC, rawphase, rawrssi, ID, SIZE, rawSIZE)

    phase = zeros(rawSIZE, SIZE);
    rssi = zeros(rawSIZE, SIZE);
    idx = zeros(rawSIZE, SIZE);
    firstT = zeros(SIZE, 1);
    endT = zeros(SIZE, 1);

    for i=1:SIZE
        idx(:,i) = ismember(rawEPC, ID(i));
        idx_n = find(idx(:,i));
        phase_unwrap = Unwrapping(rawphase(idx_n), size(rawphase(idx_n,1)));
        hum_rssi_seq = rawrssi(idx_n);
        firstT(i) = idx_n(1);
        endT(i) = idx_n(end);
        idxi = idx_n(1):1:idx_n(end);
        hum_phase_o = interp1(idx_n, phase_unwrap, idxi, 'linear');
        hum_rssi_o = interp1(idx_n, hum_rssi_seq, idxi, 'linear');
        phase(idxi, i) = hum_phase_o';
        rssi(idxi, i) = hum_rssi_o';
    end

end