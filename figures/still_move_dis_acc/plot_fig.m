close all;

figure;
load result.mat

bar(still_move_dis_acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'50', '100', '150'});
xlabel('Distance(cm)')
ylabel('Accuracy')
title('Accuracy of still vs move at various distances');
