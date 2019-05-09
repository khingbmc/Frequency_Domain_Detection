f = imread('lena.bmp');
sf = size(f);

C = [0 5];


[r, R, S] = imnoise3(sf(1), sf(2), C);
figure(2), imshow(r, []);
figure(3), imshow(S, []);

fn = (double(f) + (mat2gray(r).*255))./2;
figure(4), imshow(fn, []);

PQ = paddedsize(size(fn));
FN = fft2(fn, PQ(1), PQ(2));

FNs = fftshift(FN);
FNlog = log(1+FNs);
figure(5), imshow(uint8(abs(FNlog)), []);

[H D] = notchfilt('notch', sf(1), sf(2),C(1),C(2), 5, 8);
% H = imcomplement(S);

H1 = fftshift(H);
figure(6) , imshow(uint8(H1.*255)', []);


g = dftfilt(fn, H');
figure(7), imshow(uint8(g), []);


%f1 = medfilt2(g, [3 3], 'symmetric');
%f2 = adpmedian(g, 5);

%figure(1); imshow(f);
%figure(2); imshow(g);
%figure(3); imshow(f1);
%figure(4); imshow(f2);