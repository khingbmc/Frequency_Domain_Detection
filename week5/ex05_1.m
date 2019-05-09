clear all
close all;

C = [0 5;-2 3];
[r, R, S] = imnoise3(512, 512, C);
figure, imshow(S, []);
figure, imshow(r, []);
figure, imshow(R, []);

