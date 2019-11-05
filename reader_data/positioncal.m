function [out] = positioncal(channelfreq, phase, num)
    c = 3e8;
    centerfreq = 925.0;
    phasecor = (phase ./ channelfreq) .* centerfreq;
    out = zeros(num);
    out(1) = 0;
    for i=2:num
        lambda = c / (centerfreq * 10000);  % cm
        diffphase = phasecor(i - 1) - phasecor(i);
        if diffphase < -pi
            diffphase = diffphase + (2*pi);
        elseif diffphase > pi
            diffphase = diffphase - (2*pi);  
        end
        out(i) = out(i-1) - ((lambda * diffphase) / (4*pi));
    end
end