% Ralf Mouthaan
% University of Adelaide
% May 2024

clc; clear variables; close all;
addpath('Functions/')

%% Pre-processing

lambda = 532e-9;
NA = 0.5;

H = double(imread("20x - USAF - 160um.png"));
Ref = double(imread("20x - USAF - Ref.png"));
Truth = double(imread("20x - USAF - Truth.png"));
Mask = imread("20x - USAF - Mask.png");
Mask = double(rgb2gray(Mask))/255;
Mask = imgaussfilt(Mask, 20);

H = H./Ref;
Truth = Truth./Ref;

H = sqrt(H);
Truth = sqrt(Truth);

Nx = size(H, 2);
Ny = size(H, 1);

dx = 2.4e-6/20*200/150;
x = (0:Nx-1)*dx;
y = (0:Ny-1)*dx;
x2 = (0:2*Nx-1)*dx;
y2 = (0:2*Ny-1)*dx;

z=160e-6;

K = ASMKernel(x, y, z, lambda);
NAKernel = NAFilter(x, y, NA, lambda);
K = K.*NAKernel;

%% Show truth, show hologram, show kernel

% figure;
% imagesc(abs(K));
% axis square;

%% Gerchberg-Saxton

F = H;

for ii = 1:100

    disp(ii);

    F = Conv2_FFT(F, conj(K));
    F(abs(F) > 1) = exp(1i*angle(F(abs(F) > 1)));
    F = abs(F);
    F = F.*Mask + (1-Mask);
    F = Conv2_FFT(F, K);
    F = H.*exp(1i*angle(F));

end

% Final propagation back to object plane
F = Conv2_FFT(F, conj(K));

%% Show Result
    
figure; 

subplot(1,2,1);
imagesc(x*1e6, y*1e6, abs(F));
axis image;
xlabel('um');
ylabel('um');
title('Mag');

ang = angle(F);
ang(ang > 0.5) = ang(ang > 0.5) - 2*pi;

subplot(1,2,2);
imagesc(x*1e6, y*1e6, ang);
axis image;
xlabel('um');
ylabel('um');
title('Phase');

set(gcf,'units','normalized','outerposition',[0 0 1 1])
drawnow;

