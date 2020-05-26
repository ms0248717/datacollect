close all;

figure;
load result.mat

bar(motions_ori_acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'90', '0'});
legend({'line','shake','square','circle'}, 'Location','southeast')
xlabel('Orientation')
ylabel('Accuracy')
title('Accuracy of motions at various orientations');
