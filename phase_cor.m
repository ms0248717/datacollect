function [phase] = phase_cor(phase)
    for i=1:size(phase)
        if phase(i) > 2*pi
            while phase(i) > 2*pi
                phase(i) = phase(i) - 2*pi;
            end
        elseif phase(i) < 0
            while phase(i) < 0
                phase(i) = phase(i) + 2*pi;
            end
        end
    end
end