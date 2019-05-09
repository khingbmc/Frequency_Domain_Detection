function [] = freqText(imagePath)
image = rgb2gray(imread(imagePath));

% Original Image
% imshow(image, []);

% Get the dimension of the image.
[row columns numberOfColorBands] = size(image);
% Display of original gray scale image
subplot(2, 3, 1);
imshow(image, []);

% Take FFT.
fftImage = fft2(image);
% Shift and take log
centeredFFTImage = log(fftshift(real(fftImage)));
% Display FFT image.
subplot(2, 3, 2);
imshow(centeredFFTImage, []);


% Zero out the corners
window = 50;
fftImage(1:window, 1:window) = 0;
fftImage(end-window:end, 1:window) = 0;
fftImage(1:window, end-window:end) = 0;
fftImage(end-window:end, end-window:end) = 0;

centeredFFTImage = log(fftshift(real(fftImage)));
subplot(2, 3, 3);
imshow(centeredFFTImage, []);


% Inverse FFT to high pass filter image.
output = ifft2(fftImage);
% Display output
subplot(2, 3, 4);
imshow(real(output), []);



% compute differencing operator in the frequency domain
nx = size(image, 2);
hx = ceil(nx/2)-1;
ftdiff = (2i*pi/nx)*(0:hx);     % ik 
ftdiff(nx:-1:nx-hx+1) = -ftdiff(2:hx+1);  % correct conjugate symmetry
% compute "gradient" in x using fft
g = ifft2( bsxfun(@times, fft2(image), ftdiff) );
subplot(2, 3, 5);
imshow(g, []);      % see result

% subplot(2, 3, 6);
result = ocr(g);
  Iocr         = insertObjectAnnotation(g, 'rectangle', ...
                           result.WordBoundingBoxes, ...
                           result.WordConfidences);
% recognizedText = result.Text;
imshow(Iocr);
% text(600, 150, recognizedText, 'BackgroundColor', [1 1 1]);

