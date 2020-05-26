close all;

figure;
load result.mat

bar(mag_nmag_tag_dis_rate)
hold on;
set(gca,'xticklabel',{'30', '60', '90'});
ngroups = 3;
nbars = 2;
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mag_nmag_tag_dis_rate(:,i), mag_nmag_tag_dis_rate_std(:,i), 'b', 'linestyle', 'none');
end
legend({'non-mag','mag'}, 'Location','southeast')
grid on;
xlabel('Distance(cm)')
ylabel('Rate(t/s)')
title('Read rate');
hold off;