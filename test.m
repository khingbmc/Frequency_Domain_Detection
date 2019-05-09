clear all;
close all;

[x, y] = meshgrid(-128:127, -128:127);
z=sqrt(x.^2+y.^2);
c=z>15;
img = imread('TextureText07.jpg');
figure(1);imshow(img);
% img = squeeze(img(:, :, 1));
% figure(2);imshow(img);title('sq')
[bw, rgb]=bg_remove(img);
figure, imshow(bw), title('bw');
figure, imshow(rgb), title('rgb');
% 
% e1 = edge(img, 'prewitt');
% e2 = edge(img, 'canny');
% e3 = edge(img, 'sobel');
% e4 = edge(img, 'roberts');
% 
% subplot(2, 2, 1), imshow(e1);
% subplot(2, 2, 2), imshow(e2);
% subplot(2, 2, 3), imshow(e3);
% subplot(2, 2, 4), imshow(e4);

se = strel('disk',50);
% tophat = imtophat(im2double(img),se);
% contrastAdjusted = imadjust(tophat);
% figure(1);imshow(contrastAdjusted)
% 
% figure(1);imshow(img);title('OG IMG');

figure;imshow(img);title('Gray IMG');

F = fft2(bw);
figure(3);imshow(F);
S = abs(F);
% figure(4);imshow(S, []);

Fsh = fftshift(F);

imshow(Fsh);title('center fourier');
hb = butterhp(img, 15, 1);
Fshhb = Fsh .*hb;
imshow(Fshhb);title('Fshhb');

% S2 = log(1+abs(H1));
% % figure(6);imshow(S2, []);title('log transformed');
% 
F = ifftshift(Fshhb);
f = ifft2(F);
f = squeeze(f(:, :, 1));

figure;imshow(real(f), []);title('reconstruct img');

result = ocr(real(f));
word=result.Words{1};
wordBox = result.WordBoundingBoxes(1.0,:);
name=insertObjectAnnotation(real(f), 'rectangle', wordBox, word);
figure;imshow(name);

imwrite(name, 'test.jpg');
% 
% [bw, rgb]=bg_remove(name)
% figure, imshow(bw), title('bw_name');
% figure, imshow(rgb), title('rgb_name');


