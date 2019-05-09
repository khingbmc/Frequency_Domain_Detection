f = imread('lena.bmp');
g = imnoise(f, 'salt & pepper', 0.20);
f1 = medfilt2(g, [3 3], 'symmetric');
f2 = adpmedian(g, 5);

figure(1); imshow(f);
figure(2); imshow(g);
figure(3); imshow(f1);
figure(4); imshow(f2);