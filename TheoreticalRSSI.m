function [rssi] = TheoreticalRSSI(length)
    Ptx = -22.6; % dBm
    freq = 925 * 10^6;
    C = 3 * 10^8;
    lambda = C / freq;
    rssi =  Ptx - 20 * log10((4 .* pi .* length) ./ lambda);
end
% 20 * log10(4*pi*d/lambda)
