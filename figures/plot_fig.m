close all;

figure;
dis = [253.5666667; 255];
std = [9.194744876; 2.227105745];
bar(dis);
hold on;
set(gca,'xticklabel',{'non-mag','mag'});
errorbar(dis, std, 'b', 'Linestyle', 'None');
grid on;
xlabel('Tag')
ylabel('Distance(cm)')
title('Impact of distance');
hold off;

figure;
rate = [48.42 49; 48.98 48.32; 46.58 48.58];
std = [1.283354978, 1.334166406; 0.8786353055, 1.907092027; 1.397139936, 1.794993036];
bar(rate)
hold on;
set(gca,'xticklabel',{'30', '60', '90'});
ngroups = 3;
nbars = 2;
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, rate(:,i), std(:,i), 'b', 'linestyle', 'none');
end
legend({'non-mag','mag'}, 'Location','southeast')
grid on;
xlabel('Distance(cm)')
ylabel('Rate(t/s)')
title('Read rate');
hold off;



figure;
length = [11.705 12.645];
std=[0.3804083678, 0.372014431];
bar(length)
hold on;
set(gca,'xticklabel',{'CC4D', 'CC60'});
errorbar(length, std, 'b', 'Linestyle', 'None');
grid on;
xlabel('Mag tag')
ylabel('Length(cm)')
title('Mag-tags effective distance');
hold off;


figure;
rate = [48.5 48.5 48.6 48.6 48.7 48.6 48.6 48.7 48.6 48.6 28.9 19.6 16 6.8 0 0 0 0 0 0 0 0 0 0 0];
dis = 1:1:25;
plot(dis, rate, '-o')
grid on;
xlim([1 25])
xlabel('Distance(cm)')
ylabel('Read rate(t/s)')
title('Mag-tag read rate');

figure;
error = [0 0 0 0 0 0 0 0 1 1 2 2 2 3 3];
size = 2:1:16;
plot(size, (15-error)./15, '-o')
grid on;
xlim([2 16])
ylim([0 1])
xlabel('Object tag size')
ylabel('Accuracy')
title('1 user X N objects Pairing accuracy');

figure;
acc = [0.9333 0.875 0.85714 0.80556];
size = 1:1:4;
plot(size, acc, '-o')
grid on;
xlim([1 4])
ylim([0 1])
xlabel('User tag size')
ylabel('Accuracy')
title('N user X 10 objects Pairing accuracy');

figure;
rate = [37.25 32.29166667 29.4375 26.925 24.4375 21.875 19.984375 19.38888889 17.1125 16.43181818 15.07291667 14.69230769 13.58928571 13 12.0703125 11.09558824 11.06944444 10.63157895 9.9375];
rate1 = [37.75 37.625 37.5 37.75 37.5 37.5 37.5 37.625 37.75 37.75 37.75 37.625 37.625 37.5 37.5 37.625 37.625 37.5 37.5];
size = 2:1:20;
plot(size, rate, '-o');
hold on;
plot(size, rate1, '-d');
grid on;
xlim([2 20])
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Tag size')
ylabel('Sample rate(t/s)')
title('Compare sample rate');
hold off;

figure;
acc = [0.925 0.80556 0.77778 0.7];
acc1 = [0.95 0.95 0.95 0.95];
size = 5:5:20;
plot(size, acc, '-o');
hold on;
plot(size, acc1, '-d');
grid on;
xlim([5 20])
ylim([0 1])
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Object tag size')
ylabel('Accuracy')
title('4 users X N objects Pairing accuracy');
hold off;

figure;
D = [142.1909 164.3907 176.4586 140.359 142.353];
D1 = [39.3335 58.2682 53.5622 60.4081 53.277];
size = 20:20:100;
plot(size, D, '-o');
hold on;
plot(size, D1, '-d');
grid on;
xlim([20 100])
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Distance(cm)')
ylabel('Degree of difference')
title('Compare degree of difference');
hold off;

figure;
acc = [1 0.96 0.94; 1 1 0.86; 0.9 0.92 0.96];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'0', '30', '60'});
legend({'50cm','100cm','150cm'}, 'Location','southeast')
xlabel('Angle')
ylabel('Accuracy')
title('Accuracy of still vs move at various angles and distances');

figure;
acc = [0.9667 0.96 0.91667];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'50', '100', '150'});
xlabel('Distance(cm)')
ylabel('Accuracy')
title('Accuracy of still vs move at various distances');

figure;
acc = [0.9633 0.9533 0.92667];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'0', '30', '60'});
xlabel('Angle')
ylabel('Accuracy')
title('Accuracy of still vs move at various angles');

figure;
acc = [0.875 0.9375 0.95; 1 0.9875 0.875; 0.9875 0.9125 0.7875];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'0', '30', '60'});
legend({'50cm','100cm','150cm'}, 'Location','southeast')
xlabel('Angle')
ylabel('Accuracy')
title('Accuracy of motions at various angles and distances');

figure;
acc = [0.954167 0.945833 0.870833];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'50', '100', '150'});
xlabel('Distance(cm)')
ylabel('Accuracy')
title('Accuracy of motions at various distances');

figure;
acc = [0.92083 0.9542 0.89583];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'0', '30', '60'});
xlabel('Angle')
ylabel('Accuracy')
title('Accuracy of motions at various angles');

figure;
acc = [0.91667 0.97778 0.87222 0.92778; 0.9833 0.9889 0.7333 0.79444];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'90', '0'});
legend({'line','shake','square','circle'}, 'Location','southeast')
xlabel('Orientation')
ylabel('Accuracy')
title('Accuracy of motions at various orientations');

figure;
acc = [0.92083 0.92083 0.92361; 0.854167 0.8625 0.875];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'90', '0'});
legend({'Number of windows = 1','Number of windows = 3','Number of windows = 5'}, 'Location','southeast')
xlabel('Orientation')
ylabel('Accuracy')
title('Accuracy of motions at various number of windows');

figure;
acc = [1 1];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'non-mag', 'mag'});
xlabel('Tag')
ylabel('Accuracy')
title('Accuracy of still vs move on mag-tag');

figure;
acc = [0.854167 0.8625 0.875; 0.8375 0.8625 0.8875];
bar(acc)
grid on;
ylim([0 1])
set(gca,'xticklabel',{'non-mag', 'mag'});
legend({'Number of windows = 1','Number of windows = 3','Number of windows = 5'}, 'Location','southeast')
xlabel('Tag')
ylabel('Accuracy')
title('Accuracy of motions on mag-tag at various number of windows');

figure;
acc = [0.84 0.8 0.82 0.82 0.8 0.8 0.76];
acc1 = [0.92 0.92 0.92 0.92 0.92 0.92 0.92];
size = 1:2:13;
plot(size, acc, '-o');
hold on;
plot(size, acc1, '-d');
grid on;
xlim([1 13]);
ylim([0 1]);
xtick = [1:2:13];
set(gca,'XTickMode','manual','XTick',xtick);
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Object tag size')
ylabel('Accuracy')
title('1 user X N objects accuracy of still vs move');
hold off;

figure;
acc = [0.75 0.575 0.575 0.575 0.525 0.525 0.5];
acc1 = [0.925 0.925 0.925 0.925 0.925 0.925 0.925];
size = 1:2:13;
plot(size, acc, '-o');
hold on;
plot(size, acc1, '-d');
grid on;
xlim([1 13]);
ylim([0 1]);
xtick = [1:2:13];
set(gca,'XTickMode','manual','XTick',xtick);
legend({'non-mag','mag'}, 'Location','southeast')
xlabel('Object tag size')
ylabel('Accuracy')
title('1 user X N objects accuracy of motions');
hold off;


