clear; clc;

rawdata = readtable('./phase_2movd_8sec2.csv');

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

centerfreq = 925.0;
humID = {'BC48'};
objID = {'BE05'};
humSIZE = size(humID);
humSIZE = humSIZE(2);
objSIZE = size(objID);
objSIZE = objSIZE(2);

phasecor = (phase ./ freq) .* centerfreq;

[rawEPC, rawphase, rawrssi, rawSIZE] = AddBlank(time, EPC, phasecor, rssi, rawdataSIZE);

[hum_phase, hum_rssi ,hum_firstT, hum_endT, hum_idx] = FillBlank(rawEPC, rawphase, rawrssi, humID, humSIZE, rawSIZE);
[obj_phase, obj_rssi ,obj_firstT, obj_endT, obj_idx] = FillBlank(rawEPC, rawphase, rawrssi, objID, objSIZE, rawSIZE);

[delta_T, delta_phase, delta_rssi] = SubsetD(humSIZE, objSIZE, hum_phase, obj_phase, hum_rssi, obj_rssi, hum_firstT, obj_firstT, hum_endT, obj_endT);
