clear; clc;

stillnoise = [];
for num = 1:20
    rawdata = readtable(['./still_0_50_', num2str(num), '.csv']);
    outputfile = 'stillnoise.mat';

    %load data
    %EPC = split(string(rawdata.x___EPC_(:)));
    EPC = split(string(rawdata.EPC(:)));
    time = str2double(rawdata.Timestamp(:));
    freq = str2double(rawdata.ChannelInMhz(:));
    rssi = str2double(rawdata.PeakRssiInDbm(:));
    phase = str2double(rawdata.PhaseAngleInRadians(:));

    time = time - time(1);
    %%EPC = split(EPC);
    EPC = EPC(:,6);
    rawdataSIZE = size(EPC);
    rawdataSIZE = rawdataSIZE(1);

    %Parameter definition
    centerfreq = 925.0;
    ID = {'BDEF'};
    SIZE = size(ID);
    SIZE = SIZE(2);
    OUTPUT = true;
    FIGURE = false;

    %Calibration to center freq
    phasecor = (phase ./ freq) .* centerfreq;
    %phasecor = fixwrapping(freq, phase, rawdataSIZE);
    
    %Add blank by min delta T
    [rawEPC, rawphase, rawrssi,rawSIZE] = add_blank(time, EPC, phasecor, rssi, rawdataSIZE);

    %Unwrapping phase and filling the blank by interpolation
    [phase, rssi, firstT, endT, idx] = fill_blank(rawEPC, rawphase, rawrssi, ID, SIZE, rawSIZE);


    %output data 150 samples of phase and rssi 
    collect_sec = 8.0;
    [name, phasedata, rssidata] = output_ML_data(collect_sec, rawSIZE, SIZE, firstT, endT, phase, rssi, 'tag');
    phasedata = phasedata - mean(phasedata);
    stillnoise = [stillnoise phasedata];
end

save(outputfile, 'stillnoise');