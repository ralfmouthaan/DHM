% Ralf Mouthaan
% University of Adelaide
% August 2024
%
% Script with example processing of off-axis hologram.

clc; clear variables; close all;
addpath('Functions/')

%% User-defined parameters

Filename = 'Data/Off Axis2.png'; % Hologram file
Quadrant = 'Bottom-Right'; % Quandrant where we expect first order

%% Read in hologram

% Read in hologram
Holo = imread(Filename);
Holo = double(Holo);
Height = size(Holo, 1);
Width = size(Holo, 2);

% Display hologram
figure;
imagesc(Holo);
colormap gray;
axis image;
xticks(''); yticks('');
title('Hologram');

%% Shift to Fourier domain

% Fourier Domain
InvImg = fftshift(fft2(fftshift(Holo)));

% Display Fourier domain
figure;
imagesc(log(abs(InvImg)));
axis image;
xticks(''); yticks('');
title('Inverse Image');

%% Crop

% Based on quadrant, find location of maximum
if strcmp(Quadrant, 'Top-Left')
    
    maxmax = max(max(abs(InvImg(1:Height/2 - Height/10,1:Width/2 - Width/10))));
    [maxi, maxj] = find(abs(InvImg) == maxmax);
    if maxi(1) < maxi(2)
        maxi = maxi(1);
        maxj = maxj(1);
    elseif maxi(2) < maxi(1)
        maxi = maxi(2);
        maxj = maxj(2);
    end
    
elseif strcmp(Quadrant, 'Top-Right')
    
    maxmax = max(max(abs(InvImg(1:Height/2 - Height/10,Width/2 + Width/10:end))));
    [maxi, maxj] = find(abs(InvImg) == maxmax);
    if maxi(1) < maxi(2)
        maxi = maxi(1);
        maxj = maxj(1);
    elseif maxi(2) < maxi(1)
        maxi = maxi(2);
        maxj = maxj(2);
    end
    
elseif strcmp(Quadrant, 'Bottom-Left')
    
    maxmax = max(max(abs(InvImg(Height/2 + Height/10:end,1:Width/2 - Width/10))));
    [maxi, maxj] = find(abs(InvImg) == maxmax);
    if maxi(1) > maxi(2)
        maxi = maxi(1);
        maxj = maxj(1);
    elseif maxi(2) > maxi(1)
        maxi = maxi(2);
        maxj = maxj(2);
    end
    
elseif strcmp(Quadrant, 'Bottom-Right')
    
    maxmax = max(max(abs(InvImg(Height/2 + Height/10:end,Width/2 + Width/10:end))));
    [maxi, maxj] = find(abs(InvImg) == maxmax);
    if maxi(1) > maxi(2)
        maxi = maxi(1);
        maxj = maxj(1);
    elseif maxi(2) > maxi(1)
        maxi = maxi(2);
        maxj = maxj(2);
    end

else
    error('Quadrant not recognised');
end

% Crop Image
CropWidth = Width/4;
CropHeight = Height/4;
CropImg = InvImg(maxi-CropHeight/2:maxi+CropHeight/2, ...
    maxj-CropWidth/2:maxj+CropWidth/2);

figure;
imagesc(log(abs(CropImg)));
axis image;
xticks(''); yticks('');
title('Cropped Image');

%% Back to real domain

% Back to real domain
Img = fftshift(ifft2(fftshift(CropImg)));
mag = abs(Img);
ang = angle(Img);
ang = Unwrap(ang);

% Plot final magnitude
figure;
imagesc(mag);
axis image;
xticks(''); yticks('');
title('Magnitude');
colorbar;

figure;
imagesc(ang);
axis image;
xticks(''); yticks('');
title('Phase');
colorbar;