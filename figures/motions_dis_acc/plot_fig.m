close all;

figure;
load result.mat

bar(motions_dis_acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'50', '100', '150'});
xlabel('Distance(cm)')
ylabel('Accuracy')
title('Accuracy of motions at various distances');