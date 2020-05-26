close all;

figure;
load result.mat

bar(mag_nmag_tag_dis);
hold on;
set(gca,'xticklabel',{'non-mag','mag'});
errorbar(mag_nmag_tag_dis, mag_nmag_tag_dis_std, 'b', 'Linestyle', 'None');
grid on;
xlabel('Tag')
ylabel('Distance(cm)')
title('Impact of distance');
hold off;