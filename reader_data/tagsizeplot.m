
bad = [0,0,0,0,0,0,0,1,1,2,2,2,3,3];
x = 3:16;
y = (15 - bad)./15;
plot(x, y, '-o')
axis([3, 16, 0, 1]);
xlabel('tag size')
ylabel('accuracy')
title('Pairing accuracy')

