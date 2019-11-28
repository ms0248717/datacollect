function [rssi] = TheoreticalRSSI(length, height)
    Ptx = -22.6; % dBm
    %Ptx = -10;
    freq = 925 * 10^6;
    C = 3 * 10^8;
    lambda = C / freq;
    Gt = 10;
    tagL = 30;
    rssi = zeros(150 , 1);
    %rssi =  Ptx - 20 * log10((4 .* pi .* length) ./ lambda);
    for i = 1:150
        if(length(i) == 0 || height(i) == 0)
            rssi(i) = -80;
        else
            rssi(i) = Ptx +  10 * log10((Gt * lambda^2 .* (tagL * (height(i) / length(i)))) ./ ((4 * pi)^3 * length(i).^4));
        end
    end
    %rssi = Ptx +  10 * log10((Gt * lambda^2 .* (tagL * (height / length))) ./ ((4 * pi)^3 * length.^4));
end
% 20 * log10(4*pi*d/lambda)
