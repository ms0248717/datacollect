%function [output] = reader_cal(name)
    %tag_info = csvread("phase.csv",2,1);

    %[EPC, timestamp, channelfreq, RSSI, phase] = textread('phase.csv', '%s %s %f %f %f', 2);
    %buffer = fileread('phase.csv') ;
    %name = 'Reader_data/phase_sta_2tag_5sec_18cm4.csv';
    %name = 'Reader_data/phase_2movd_8sec1.csv';phase_2mov_8sec6
    clear; clc;name = 'phase_2movd_8sec2.csv';
    buffer = fileread(name);
    show_di = name(find(isstrprop(name,'digit')));
    %header = textscan(buffer,'%s %s %s %s %s','delimiter', ',');
    %data = textscan(buffer,'%s %s %s %s %s','delimiter', ',', 'headerlines', 1, 'whitespace', '');
    data = textscan(buffer,'%s %s %f %f %f','delimiter', ',', 'headerlines', 1, 'whitespace', '');
    
    
    tag_ID = ['05'; '48'];
    %tag_ID = ['E7'; 'E8'];
    %tag_ID = ['E7'; '48'];
    b = readtable(name);
    b = table2array(b);
    EPC = cell2mat(b(1:end,1));
    timestamp = str2double(b(:,2));
    channelfreq = str2double(b(:,3));
    RSSI = str2double(b(:,4));
    phase = str2double(b(:,5));
    EPC = EPC(:,size(EPC,2)-1:size(EPC,2));
    
    
%return
    idx_1 = all(ismember(EPC,tag_ID(1,1:2)),2);
    tag1 = find(idx_1); % tag ID position
    idx_2 = all(ismember(EPC,tag_ID(2,1:2)),2);
    tag2 = find(idx_2);
   
    phase_1 = phase(tag1);
    channelfreq_1 = channelfreq(tag1);
    position_1 = positioncal_o(channelfreq_1, phase_1, size(tag1));
    figure();plot(position_1);
    xlabel('samples')
    ylabel('position(cm)')
    phase_2 = phase(tag2);
    channelfreq_2 = channelfreq(tag2);
    position_2 = positioncal_o(channelfreq_2, phase_2, size(tag2));
    figure();plot(position_2);
    xlabel('samples')
    ylabel('position(cm)')
    
    delta_t = zeros(size(timestamp));
    for i=2:size(timestamp)
        delta_t(i) = timestamp(i) - timestamp(i-1);
    end
    figure;
    plot(floor(delta_t / min(delta_t(2:end))),'*')
    tag1_op = zeros(size(position_1));
    tag1_ts = zeros(size(position_1));
    tag2_op = zeros(size(position_2));
    tag2_ts = zeros(size(position_2));
    samplesize = sum(floor(delta_t / min(delta_t(2:end))));
    delta_tidx = floor(delta_t / min(delta_t(2:end)));
    allposition_1 = zeros(samplesize,1);
    allposition_2 = zeros(samplesize,1);
    tag1_idx = 2;
    tag1_interpolation = 0;
    tag1_allidx = 1;
    tag2_idx = 2;
    tag2_interpolation = 0;
    tag2_allidx = 1;
    for i = 1:size(channelfreq)
        tag1_interpolation = tag1_interpolation + delta_tidx(i);
        tag2_interpolation = tag2_interpolation + delta_tidx(i);
        if(idx_1(i) == 1)
            if(i == tag1(1))
                tag1_idx = 2;
            else
                difpos = position_1(tag1_idx) -  position_1(tag1_idx - 1);
                for j=1:tag1_interpolation
                    allposition_1(j + tag1_allidx) = (difpos / tag1_interpolation) * j + position_1(tag1_idx - 1);
                end
                tag1_allidx = tag1_allidx + tag1_interpolation;
                tag1_op(tag1_idx) = position_1(tag1_idx);
                tag1_ts(tag1_idx) = tag1_allidx;
                tag1_idx = tag1_idx + 1;
                tag1_interpolation = 0;
            end
        else
            if(i == tag2(1))
                tag2_idx = 2;
            else
                difpos = position_2(tag2_idx) -  position_2(tag2_idx - 1);
                for j=1:tag2_interpolation
                    allposition_2(j + tag2_allidx) = (difpos / tag2_interpolation) * j + position_2(tag2_idx - 1);
                end
                tag2_allidx = tag2_allidx + tag2_interpolation;
                tag2_op(tag2_idx) = position_2(tag2_idx);
                tag2_ts(tag2_idx) = tag2_allidx;
                tag2_idx = tag2_idx + 1;
                tag2_interpolation = 0;
            end
        end
    end
    figure();plot(allposition_1);
    hold on;
    plot(tag1_ts, tag1_op, 'o');
    figure();plot(allposition_2);
    hold on;
    plot(tag2_ts, tag2_op, 'o');
    return;
    claON = 0;
    ph_1 = phasecal(channelfreq, phase, tag1, claON, timestamp);
    %return
    ph_2 = phasecal(channelfreq, phase, tag2, claON, timestamp);
    %return; % 0526
    figure();
    dtw(ph_1, ph_2)
return
    figure();plot(ph_1);
    title(['Tag ID "' tag_ID(1,1:2) '" phase ' show_di]);
    ylim([-7 7]);
    %xlim([0 90]);
    xlabel('samples')
    ylabel('phase (-pi~pi)')
    figure();plot(ph_2);
    title(['Tag ID "' tag_ID(2,1:2) '" phase ' show_di]);
    ylim([-7 7]);
    %xlim([0 90]);
    xlabel('samples')
    ylabel('phase (-pi~pi)')
    
    

%end
%{
return
set(h_figure, 'PaperPositionMode', 'manual');
set(h_figure, 'PaperUnits', 'inches');
set(h_figure, 'Units', 'inches');
set(h_figure, 'PaperPosition', [0, 0, 5 1.8]);
set(h_figure, 'Position', [0, 0, 5 1.8]); 
print(h_figure, '-depsc', 'whole_one_raw.eps');
%}