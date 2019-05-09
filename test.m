clear all;
close all;


img = imread('TextureText02.jpg');

se = strel('disk',50);
% tophat = imtophat(im2double(img),se);
% contrastAdjusted = imadjust(tophat);
% figure(1);imshow(contrastAdjusted)
% 
% figure(1);imshow(img);title('OG IMG');

gray_img = rgb2gray(img);
figure(2);imshow(gray_img);title('Gray IMG');

F = fft2(gray_img);
figure(3);imshow(F);
S = abs(F);
% figure(4);imshow(S, []);

Fsh = fftshift(F);
% figure(5);imshow(Fsh, []);title('center fourier');

S2 = log(1+abs(Fsh));
% figure(6);imshow(S2, []);title('log transformed');

F = ifftshift(Fsh);
f = ifft2(F);
figure(7);imshow(f, []);title('reconstruct img');
