function [distance] = distance_cal(channelfreq, phase, num)
    C = 3 * 10^8;
    distance = zeros(num, 1);
    for i=2:num
        lambda = C / (channelfreq(i) * 1000000);  % cm
        if channelfreq(i) ~= channelfreq(i-1)
            distance(i) = distance(i-1);
        else
            diffphase = phase(i - 1) - phase(i);
            if diffphase < -pi*3/2
                diffphase = diffphase + (2*pi);
            elseif diffphase > pi*3/2
                diffphase = diffphase - (2*pi);  
            elseif diffphase < -pi/2
                diffphase = diffphase + pi;
            elseif diffphase > pi/2
                diffphase = diffphase - pi;
            end
            distance(i) = distance(i-1) - ((lambda * diffphase) / (4*pi));
        end
    end
end