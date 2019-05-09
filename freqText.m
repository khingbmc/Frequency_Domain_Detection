function [] = freqText(imagePath)

close all;

image = rgb2gray(imread(imagePath));

% Original Image
% imshow(image, []);

% Get the dimension of the image.
[row columns numberOfColorBands] = size(image);
% Display of original gray scale image
subplot(2, 2, 1);
imshow(image, []);

% Take FFT.
fftImage = fft2(image);
% Shift and take log
centeredFFTImage = log(fftshift(real(fftImage)));
% Display FFT image.
subplot(2, 2, 2);
imshow(centeredFFTImage, []);


% Zero out the corners
window = 15;
fftImage(1:window, 1:window) = 0;
fftImage(end-window:end, 1:window) = 0;
fftImage(1:window, end-window:end) = 0;
fftImage(end-window:end, end-window:end) = 0;

centeredFFTImage = log(fftshift(real(fftImage)));
subplot(2, 2, 3);
imshow(centeredFFTImage, []);


% Inverse FFT to high pass filter image.
output = ifft2(fftImage);
% Display output
subplot(2, 2, 4);
imshow(real(output), []);



% Remove keypad background.
Icorrected = imtophat(image,strel('disk',15));

BW1 = imbinarize(Icorrected);

figure; 
imshowpair(Icorrected,BW1,'montage');

% Perform morphological reconstruction and show binarized image.
marker = imerode(Icorrected, strel('line',5,0));
Iclean = imreconstruct(marker, Icorrected);

BW2 = imbinarize(Iclean);

figure; 
imshowpair(Iclean,BW2,'montage');





% Initialize the blob analysis System object(TM).
blobAnalyzer = vision.BlobAnalysis('MaximumCount',500);

% Run the blob analyzer to find connected components and their statistics.
[area,centroids,roi] = step(blobAnalyzer,BW2);

areaConstraint = area > 300;
% Keep regions that meet the area constraint.
roi = double(roi(areaConstraint, :));

% Show remaining blobs after applying the area constraint.
img = insertShape(image,'rectangle',roi);


results = ocr(BW2, roi,'TextLayout','Block', 'CharacterSet', 'abcdefghigklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWSYZ')
text = deblank( {results.Text} );
text = regexprep(text,'[\n\r]+','')
img  = insertObjectAnnotation(image,'rectangle',roi,text);

figure;
imshow(img);