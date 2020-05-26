close all;

figure;
load result.mat

size = 1:1:4;
plot(size, nUX10O_pair_acc, '-o')
grid on;
xlim([1 4])
ylim([0 1])
xlabel('User tag size')
ylabel('Accuracy')
title('N user X 10 objects Pairing accuracy');
