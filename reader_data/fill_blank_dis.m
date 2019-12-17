function [phase, rssi, distance, firstT, endT, idx] = fill_blank_dis(rawEPC, rawphase, rawrssi, rawdistance, ID, SIZE, rawSIZE)

    phase = zeros(rawSIZE, SIZE);
    rssi = zeros(rawSIZE, SIZE);
    distance = zeros(rawSIZE, SIZE);
    idx = zeros(rawSIZE, SIZE);
    firstT = zeros(SIZE, 1);
    endT = zeros(SIZE, 1);

    for i=1:SIZE
        idx(:,i) = ismember(rawEPC, ID(i));
        idx_n = find(idx(:,i));
        %Unwrapping the phase
        phase_unwrap = unwrapping(rawphase(idx_n), size(rawphase(idx_n,1)));
        rssi_seq = rawrssi(idx_n);
        distance_seq = rawdistance(idx_n);
        firstT(i) = idx_n(1);
        endT(i) = idx_n(end);
        idxi = idx_n(1):1:idx_n(end);
        %interpolate the phase and rssi (linear, spline)
        phase_o = interp1(idx_n, phase_unwrap, idxi, 'linear');
        rssi_o = interp1(idx_n, rssi_seq, idxi, 'linear');
        distance_o = interp1(idx_n, distance_seq, idxi, 'linear');
        phase(idxi, i) = phase_o';
        rssi(idxi, i) = rssi_o';
        distance(idxi, i) = distance_o';
    end

end