close all;

figure;
load result.mat

size = 2:1:20;
plot(size, nmag_sample_rate, '-o');
hold on;
plot(size, mag_sample_rate, '-d');
grid on;
xlim([2 20])
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Tag size')
ylabel('Sample rate(t/s)')
title('Compare sample rate');
hold off;