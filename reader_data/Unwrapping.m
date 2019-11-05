function [phase_unwrap] = Unwrapping(phase, num)
    %phase_unwrap = zeros(num);
    for i=1:num-1
        if(phase(i+1) - phase(i)) > 2*pi*(2/3)
            phase(i+1:end) = phase(i+1:end) - (2 * pi);
        elseif (phase(i+1) - phase(i)) < -2*pi*(2/3)
            phase(i+1:end) = phase(i+1:end) + (2 * pi);
        end
    end
    phase_unwrap = phase;
end