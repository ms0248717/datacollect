function [out] = positioncal_o(channelfreq, phase, num)
    c = 3e8;
    out = zeros(num);
    out(1) = 0;
    for i=2:num
        lambda = c / (channelfreq(i) * 10000);  % cm
        if channelfreq(i) ~= channelfreq(i-1)
            out(i) = out(i-1);
        else
            diffphase = phase(i - 1) - phase(i);
            if diffphase < -2*pi+(pi/2)
                diffphase = diffphase + (2*pi);
            elseif diffphase > 2*pi-(pi/2)
                diffphase = diffphase - (2*pi);  
            end
            out(i) = out(i-1) - ((lambda * diffphase) / (4*pi));
        end
    end
end