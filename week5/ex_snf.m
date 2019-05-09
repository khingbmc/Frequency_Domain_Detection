f = imread('lena.bmp');
[M, N] = size(f);
R = imnoise2('Salt & Pepper',M, N, 0.1, 0);
c = find(R == 0);
gp = f;
gp(c) = 0;

figure(1);imshow(f);
figure(2);imshow(gp);

R = imnoise2('Salt & Pepper', M, N, 0, 0.1);
c = find(R==1);
gs = f;
gs(c) = 255;
figure(3); imshow(gs);

fp = spfilt(gp, 'chmean', 3, 3, 1.5);
figure(4);imshow(fp);

fs = spfilt(gs, 'chmean', 3, 3, -1.5);
figure(5);imshow(fs);

fpmax = spfilt(gp, 'max', 3, 3);
fsmin = spfilt(gs, 'min', 3, 3);

figure(6);imshow(fpmax);
figure(7);imshow(fsmin);