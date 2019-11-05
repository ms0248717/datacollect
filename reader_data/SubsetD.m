function [phase, rssi ,firstT, endT, idx] = SubsetD(rawEPC, rawphase, rawrssi, ID, SIZE, rawSIZE)

    phase = zeros(rawSIZE, SIZE);
    rssi = zeros(rawSIZE, SIZE);
    idx = zeros(rawSIZE, SIZE);
    firstT = zeros(SIZE, 1);
    endT = zeros(SIZE, 1);

    for i=1:SIZE
        idx(:,i) = ismember(rawEPC, ID(i));
        idx = find(idx(:,i));
        phase_unwrap = Unwrapping(rawphase(idx), size(rawphase(idx,1)));
        hum_rssi_seq = rawrssi(idx);
        firstT(i) = idx(1);
        endT(i) = idx(end);
        idxi = idx(1):1:idx(end);
        hum_phase_o = interp1(idx, phase_unwrap, idxi, 'spline');
        hum_rssi_o = interp1(idx, hum_rssi_seq, idxi, 'spline');
        phase(idxi, i) = hum_phase_o';
        rssi(idxi, i) = hum_rssi_o';
    end

end