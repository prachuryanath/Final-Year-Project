close all;
clear all;
clc;

%% Image input

rgbImage = imread("Basic_pp\163.jpg");
rgbImage = im2double(rgbImage);
grayImage = rgb2gray(rgbImage);

%% White Balancing

redChannel = rgbImage(:, :, 1);
meanR = mean2(redChannel);
greenChannel = rgbImage(:, :, 2);
meanG = mean2(greenChannel);
blueChannel = rgbImage(:, :, 3);
meanB = mean2(blueChannel);

meanGray = mean2(grayImage);

redChannel = (double(redChannel) * meanGray / meanR);
greenChannel = (double(greenChannel) * meanGray / meanG);
blueChannel = (double(blueChannel) * meanGray / meanB);

redChannel=redChannel-0.3*(meanG-meanR).*greenChannel.*(1-redChannel);
blueChannel=blueChannel+0.3*(meanG-meanB).*greenChannel.*(1-blueChannel);

rgbImage_white_balance = cat(3, redChannel, greenChannel, blueChannel);

%% Gamma Correction and sharpening

I = imadjust(rgbImage_white_balance,[],[],0.5);
J = (rgbImage_white_balance+(rgbImage_white_balance-imgaussfilt(rgbImage_white_balance)));

%% Image Fusion using wavelet transform

XFUS = wfusimg(I,J,'sym4',3,'max','max');

%% Final comparison

figure('Name','Final Comparison');

subplot(221);
imshow(rgbImage_white_balance);
title('I. After White balance');

subplot(222);
imshow(I);
title('II. Gamma Corrected');

subplot(223);
imshow(J);
title('III. Sharpened');

subplot(224);
imshow((histeq(XFUS)));
title('IV. Final Wavelet fusion');
