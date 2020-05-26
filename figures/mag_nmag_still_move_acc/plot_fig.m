close all;

figure;
load result.mat

bar(mag_nmag_still_move_acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'non-mag', 'mag'});
xlabel('Tag')
ylabel('Accuracy')
title('Accuracy of still vs move on mag-tag');