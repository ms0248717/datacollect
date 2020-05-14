close all;

figure;
load result.mat

bar(still_move_ang_acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'0', '30', '60'});
xlabel('Angle')
ylabel('Accuracy')
title('Accuracy of still vs move at various angles');
