close all
clear all
%%%%%%  Simulate blur effect   %%%%%%%


%%%% This file creates a blurred image and then de-blurs it using weiner
%%%% filter

%%%% The output of this file is later used in the OCR program to test the
%%%% working of a deblurred image

character = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
I = im2double(imread('texture text.jpg'));
figure,imshow(I);
title('Original Image');

LEN = 5;
THETA = 40;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
% figure, imshow(blurred)
% title('Simulate Blur');

noise_mean = 0;
noise_var = 0.000001;
blurred_noisy = imnoise(blurred, 'gaussian', ...
                        noise_mean, noise_var);
figure, imshow(blurred_noisy)
title('Simulate Blur and Noise');

estimated_nsr = 0;
wnr2 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure, imshow(wnr2)
title('Restoration of Blurred, Noisy Image Using NSR = 0');

estimated_nsr = noise_var / var(I(:));
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure, imshow(wnr3)
title('Restoration of Blurred, Noisy Image Using Estimated NSR');

Igray = rgb2gray(wnr3);
figure;
imshow(Igray)
title('Gray Image');

% use median filter
imagen = medfilt2(Igray,[5 5]);
figure;
imshow(imagen);
title('Median Filter');

% use adaptive histogram equalisation
imagen = adapthisteq(imagen);
figure;
imshow(imagen);
title('Adaptive Histogram Equalisation');

% contrast stretching
imagen = imadjust(imagen);
figure;
imshow(imagen);
title('Contrast Stretching');

% Convert to binary image
Ibw = imbinarize(imagen);
figure;
imshow(Ibw)
title('Convert to binary image');

% Edge detection
Iedge = edge(uint8(Ibw));
figure;
imshow(Iedge)
title('Edge detection');

% Image Dilation
se = strel('square',2);
Iedge2 = imdilate(Iedge, se);
figure;
imshow(Iedge2)
title('Image Dilation');

%Image Filling
Ifill= imfill(Iedge2,'holes');
figure;
imshow(Ifill)
title('Image Filling');



% TEXT DETECTION ZONE %
results = ocr(Ifill,'CharacterSet', character, 'TextLayout','Block');
results.Text

% Sort the character confidences.
[sortedConf, sortedIndex] = sort(results.CharacterConfidences, 'descend');

% Keep indices associated with non-NaN confidences values.
indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );

% Get the top ten indexes.
topTenIndexes = indexesNaNsRemoved(1:end);

% Select the top ten results.
digits = num2cell(results.Text(topTenIndexes));
bboxes = results.CharacterBoundingBoxes(topTenIndexes, :);

Idigits = insertObjectAnnotation(I,'rectangle',bboxes,digits);

figure; 
imshow(Idigits);
