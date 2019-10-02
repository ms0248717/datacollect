function [rssi] = TheoreticalRSSI(length)
    freq = 925 * 10^6;
    C = 3 * 10^8;
    lambda = C / freq;
    rssi = 20 * log10(lambda ./ (4 .* pi .* length)) - 22.6;
end