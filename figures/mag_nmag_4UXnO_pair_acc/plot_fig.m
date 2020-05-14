close all;

figure;
load result.mat

size = 5:5:20;
plot(size, nmag_4UXnO_pair_acc, '-o');
hold on;
plot(size, mag_4UXnO_pair_acc, '-d');
grid on;
xlim([5 20])
ylim([0 1])
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Object tag size')
ylabel('Accuracy')
title('4 users X N objects Pairing accuracy');
hold off;