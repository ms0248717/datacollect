close all;

figure;
load result.mat

size = 1:2:13;
plot(size, nmag_1UXnO_motions_acc, '-o');
hold on;
plot(size, mag_1UXnO_motions_acc, '-d');
grid on;
xlim([1 13]);
ylim([0 1]);
xtick = [1:2:13];
set(gca,'XTickMode','manual','XTick',xtick);
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Object tag size')
ylabel('Accuracy')
title('1 user X N objects accuracy of motions');
hold off;