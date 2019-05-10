clear all;
close all;

character = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';


[x, y] = meshgrid(-128:127, -128:127);
z=sqrt(x.^2+y.^2);
c=z>15;
img = imread('TextureText07.jpg');
figure(1);imshow(img);


figure(2);imshow(img);title('sq')
[bw, rgb]=bg_remove(img);
figure, imshow(bw), title('bw');
figure, imshow(rgb), title('rgb');


se = strel('disk',50);



figure;imshow(img);title('Gray IMG');

F = fft2(real(bw));
figure(3);imshow(F);
S = abs(F);
% figure(4);imshow(S, []);

Fsh = fftshift(F);

imshow(Fsh);title('center fourier');
hb = butterhp(Fsh, 15, 1);
Fshhb = Fsh .*hb;
imshow(Fshhb);title('Fshhb');

% S2 = log(1+abs(H1));
% % figure(6);imshow(S2, []);title('log transformed');
% 
F = ifftshift(Fshhb);
f = ifft2(F);
f = squeeze(f(:, :, 1));

figure;imshow(f, []);title('reconstruct img');
f = real(f)

% convert to binary
f = imbinarize(f);
figure, imshow(f), title('binary');

% edge detection
f_edge = edge(f, 'Canny');
figure, imshow(f_edge), title('sobel');

f_dilate = imfill(f,'holes');
figure, imshow(f_dilate), title('Original')
f_dilate = bwmorph(f_dilate, 'remove');

f_dilate = imclose(f_dilate, strel('disk', 15));

% se = strel('line',15,90);
% f_dilate= imdilate(f_dilate,se);
figure, imshow(f_dilate), title('Original')


result = ocr(f_dilate, 'CharacterSet', character,'TextLayout','Block');
word=result.Text;
word=regexprep(word,'[\n\r]+', '');
[sortedConf, sortedIndex] = sort(result.CharacterConfidences, 'descend');
indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );

% Get the top ten indexes.
topTen = indexesNaNsRemoved(1:end);
predict = num2cell(result.Text(topTen));


wordBox = result.CharacterBoundingBoxes(topTen, :);
name=insertObjectAnnotation(img, 'rectangle', wordBox, predict);
figure;imshow(name);



% 
% [bw, rgb]=bg_remove(name)
% figure, imshow(bw), title('bw_name');
% figure, imshow(rgb), title('rgb_name');


