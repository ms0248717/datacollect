function [rssi] = TheoreticalRSSI(length, height)
    Ptx = -22.6; % dBm
    %Ptx = -10;
    freq = 925 * 10^6;
    C = 3 * 10^8;
    lambda = C / freq;
    Gt = 10;
    tagL = 50;
    rssi = zeros(150 , 1);
    %length
    %height
    length = normalize(length, 'range');
    length = length * 0.5;
    length = length + 1.5;
    %rssi =  Ptx - 20 * log10((4 .* pi .* length) ./ lambda);
    for i = 1:150
        rssi(i) = Ptx +  10 * log10((Gt * lambda^2 .* (tagL * (height(i) / length(i)))) ./ ((4 * pi)^3 * length(i).^4));
    end
    %rssi = Ptx +  10 * log10((Gt * lambda^2 .* (tagL * (height / length))) ./ ((4 * pi)^3 * length.^4));
end
% 20 * log10(4*pi*d/lambda)
