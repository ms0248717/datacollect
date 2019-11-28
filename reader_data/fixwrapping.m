function [phasecor] = fixwrapping(freq, phase, rawdataSIZE)
    for i=1:rawdataSIZE-1
        if freq(i) ~= freq(i + 1)
            phase(i+1:end) = phase(i+1:end) - (phase(i+1) - phase(i));
        end
    end
    phasecor = phase;
end