function [rawEPC, rawphase, rawrssi, rawSIZE] = add_blank(time, EPC, phasecor, rssi, rawdataSIZE)

    delta_time = zeros(rawdataSIZE-1,1);
    for i=1:rawdataSIZE-1
        delta_time(i) = time(i+1) - time(i);
    end
    %min delta_T
    min_d_time = min(delta_time);
    while(min_d_time > 15000)
        min_d_time = min_d_time / 2;
    end
    delta_time = floor(delta_time ./ min_d_time);
    rawSIZE = sum(delta_time) + 1;

    rawEPC = strings(rawSIZE, 1);
    rawphase = zeros(rawSIZE, 1);
    rawrssi = zeros(rawSIZE, 1);

    now = 1;
    rawEPC(1) = EPC(1);
    rawphase(1) = phasecor(1);
    rawrssi(1) = rssi(1);
    for i=1:rawdataSIZE-1
        now = now + delta_time(i);
        rawEPC(now) = EPC(i+1);
        rawphase(now) = phasecor(i+1);
        rawrssi(now) = rssi(i+1);
    end

end