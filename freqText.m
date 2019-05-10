function [] = freqOcr()
image = imread('TextureText07.jpg');
close all;

% [row, col, dim] = size(img)
figure(1), imshow(image);

% Make img to Grayscale
g = rgb2gray(image);

f = fft2(g);
fc = fftshift(f);

S = log(1 + abs(fc));

[m, n] = size(g);
r = 1;
x = 0:n-1;
y = 0:m-1;
[x, y] = meshgrid(x, y);
Cx = 0.5*n;
Cy = 0.5*m;
lp = exp(-((x-Cx).^2+(y-Cy).^2)./(2*r).^2);
hi = 1 - lp;
hi = imbinarize(real(hi));
imshow(hi);
fc1 = fc.*hi;

S = log(1+abs(fc1));
figure(3), imshow(abs(S), []);

i = ifftshift(fc1);
b = ifft2(i);

figure(4), imshow(abs(b), []), title('Low pass frequency domain');

b = imbinarize(real(b));
b = squeeze(b(:, :, 1));
b = bwmorph(b,'thin', 2);
b = bwmorph(b,'remove');
figure;imshow(b);
bw = im2bw(image);
b = b.*bw
b = imopen(b, strel('square', 1));
b = imclose(b, strel('disk', 5));
b = imopen(b, strel('square', 1));
b = imbinarize(real(b));
figure;imshow(b);

% Initialize the blob analysis System object(TM).
blobAnalyzer = vision.BlobAnalysis('MaximumCount',500);

% Run the blob analyzer to find connected components and their statistics.
[area,centroids,roi] = step(blobAnalyzer,b);

areaConstraint = area > 300;
% Keep regions that meet the area constraint.
roi = double(roi(areaConstraint, :));

% Show remaining blobs after applying the area constraint.
img = insertShape(image,'rectangle',roi);


results = ocr(b, roi,'TextLayout','Block', 'CharacterSet', 'abcdefghigklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWSYZ')
text = deblank( {results.Text} );
text = regexprep(text,'[\n\r]+','')
img  = insertObjectAnnotation(image,'rectangle',roi,text);

figure;
imshow(img);
% fh = imadjust(fc1,[0 1],[1 0]);
% fh = imbinarize(real(fh));
% 
% fh = fc.*fh;
% %S2 = log(1+abs(fh));
% figure(4), imshow(fh, []);
% % 
% i2 = ifftshift(fh);
% b2 = ifft2(i2);
% % 
% figure(5), imshow(abs(b2), []), title('integrate low pass');

% ic = imreconstruct(imerode(real(b2),ones());
% bw = imbinarize(ic);

% figure(6), imshow(bw);

end