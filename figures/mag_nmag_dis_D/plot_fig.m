close all;

figure;
load result.mat

size = 20:20:100;
plot(size, nmag_dis_D, '-o');
hold on;
plot(size, mag_dis_D, '-d');
grid on;
xlim([20 100])
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Distance(cm)')
ylabel('Degree of difference')
title('Compare degree of difference');
hold off;