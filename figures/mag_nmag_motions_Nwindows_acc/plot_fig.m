close all;

figure;
load result.mat

bar(mag_nmag_motions_Nwindows_acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'90', '0'});
legend({'Number of windows = 1','Number of windows = 3','Number of windows = 5'}, 'Location','southeast')
xlabel('Orientation')
ylabel('Accuracy')
title('Accuracy of motions at various number of windows');