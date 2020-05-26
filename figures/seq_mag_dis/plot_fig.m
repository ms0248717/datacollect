close all;

figure;
load result.mat

bar(sep_mag_dis)
hold on;
set(gca,'xticklabel',{'CC4D', 'CC60'});
errorbar(sep_mag_dis, sep_mag_std, 'b', 'Linestyle', 'None');
grid on;
xlabel('Mag tag')
ylabel('Length(cm)')
title('Mag-tags effective distance');
hold off;
