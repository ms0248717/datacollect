close all;

figure;
load result.mat

dis = 1:1:25;
plot(dis, sep_mag_dis_rate, '-o')
grid on;
xlim([1 25])
xlabel('Distance(cm)')
ylabel('Read rate(t/s)')
title('Mag-tag read rate');
