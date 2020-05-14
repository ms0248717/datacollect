close all;

figure;
load result.mat

bar(motions_acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'0', '30', '60'});
legend({'50cm','100cm','150cm'}, 'Location','southeast')
xlabel('Angle')
ylabel('Accuracy')
title('Accuracy of motions at various angles and distances');