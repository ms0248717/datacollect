function [out] = phasecal(channelfreq, phase, tag, claON, timest)

    medi = median(channelfreq(tag));
    medi_can = find(all(channelfreq(tag) == medi, 2));
    med_ph = mean(phase(medi_can));

    mod = mode(channelfreq(tag));
    mod_can = find(all(channelfreq(tag) == mod, 2));
    mod_ph = mean(phase(mod_can));
    
    T = (timest(end) - timest(1))/size(timest,1); % s./query round
    thres = T * 1.5;
    %xi = timest(1):T:timest(end);
    
    % find the exclude indices
    aa = ones(size(timest,1),1);
    aa(tag) = 0;
    Comp = find(aa == 1);
    %xi = Comp;
    time_tag_tmp = timest(tag);
    % diff between each two elements
    time_tag = [timest(1); time_tag_tmp; timest(end)];
    % find the distance over threshold
    diff_time = diff(time_tag); % n x 1
    over_thres = find(diff_time>thres);
    bon_ts = floor(diff_time(over_thres)./T);
    %over_thres
    xi = [];
    for i =1:size(over_thres,1)
        %over_thres(i)
        xi = [xi (time_tag(over_thres(i))+1*T):T:(time_tag(over_thres(i)) + bon_ts(i)*T)];
    end
    %return
    % collibration
    if claON
        ph = phase(tag) - med_ph + mod_ph;
    else
        ph = phase(tag);
    end
    
    % convert 0~2pi to -pi~pi
    idx = find(ph>pi);
    ph(idx) = ph(idx) - 2*pi;
    
    for i=1:size(ph,1)-1
        if ph(i+1)>3 && ph(i) < -2.5
            ph(i+1) = ph(i+1) -2*pi;
        elseif ph(i+1)< -3 && ph(i) >2.5
            ph(i+1) = ph(i+1) +2*pi;
        end
    end
    
    x = time_tag_tmp;
    y = ph;
    figure();
    if isempty(xi)
        xi = x;
    end
    
    out = interp1(x, y, xi, 'spline');
    %out = interp1(x, y, xi, 'nearest');
    plot(xi,out,'blue');hold on;scatter(xi,out,'blue','*');
    scatter(x,y,'r');hold off;
    c = categorical({'interp.', 'interp.', 'origin'});
    c = cellstr(c);
    legend(c);
    div = 1000;
    
    %return
    %size(xi)
    for i = 0:size(out,2)/1000
        if(size(out(i*1000+1:end),2)<1000)
            div = size(out(i*1000+1:end),2)-1;
        end
        out(i*1000+1) = mean(out(i*1000+1:i*1000+1+div));
    end
    %out = ph;
    %ph
end