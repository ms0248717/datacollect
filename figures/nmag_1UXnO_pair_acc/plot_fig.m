close all;

figure;
load result.mat

size = 2:1:16;
plot(size, (15-pair_error)./15, '-o')
grid on;
xlim([2 16])
ylim([0 1])
xlabel('Object tag size')
ylabel('Accuracy')
title('1 user X N objects Pairing accuracy');
