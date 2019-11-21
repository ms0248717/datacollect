
bad = [0,0,0,0,0,1,2,2,2,2,3,6,6];
x = 3:15;
y = (20 - bad)./20;
plot(x, y, '-o')
axis([3, 15, 0, 1]);
xlabel('tag size')
ylabel('accuracy')
title('Pairing accuracy')

