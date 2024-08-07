% Ralf Mouthaan
% University of Adelaide
% May 2024

clc; clear variables; close all;
addpath('Functions/')

%% Pre-processing

lambda = 532e-9;
NA = 0.5;

H = double(imread("20x - USAF - 110um.png"));
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

z = 110e-6;

K = ASMKernel(x, y, z, lambda);
NAKernel = NAFilter(x, y, 4*NA, lambda);
K = K.*NAKernel;

K_inv = conj(K);
%A = K_inv.*K - ones(size(K));
A = K_inv.*K - NAFilter(x, y, NA, lambda);

%% Show truth, show hologram, show kernel

% figure;
% imagesc(x*1e6, y*1e6, Truth);
% title('Truth');
% axis image;
% 
% SimH = Conv2_FFT(Truth, K);
% 
% figure;
% subplot(1,2,1);
% imagesc(x*1e6, y*1e6, abs(SimH));
% title('Simulated Hologram')
% axis image;
% colorbar;
% clim([0.8 1.2]);
% 
% subplot(1,2,2);
% imagesc(x*1e6, y*1e6, H);
% title('Measured Hologram');
% axis image;
% colorbar;
% clim([0.8 1.2])

%% Yang-Gu

% Starting values
U2 = H;
U1 = zeros(size(U2));

for ii = 1:100

    disp(ii);

    % Propagate back to object plane
    for jj = 1:3
        U1 = Conv2_FFT(U2, K_inv) - Conv2_FFT(U1, A);
        U1(abs(U1) > 1) = exp(1i*angle(U1(abs(U1) > 1)));
        U1 = abs(U1);
        U1 = U1.*Mask + (1-Mask);
    end

    % Propagate to hologram plane
    % Impose hologram amplitude constraints
    U2 = Conv2_FFT(U1, K);
    U2 = H.*exp(1i*angle(U2));

end

% Final propagation back to object plane
for jj = 1:3
    U1 = Conv2_FFT(U2, K_inv) - Conv2_FFT(U1, A);
end

%% Show Result

figure;
    
subplot(1,2,1);
imagesc(x*1e6, y*1e6, abs(U1));
axis image;
xlabel('um');
ylabel('um');
title('Mag');

ang = angle(U1);
ang(ang > 0.5) = ang(ang > 0.5) - 2*pi;

subplot(1,2,2);
imagesc(x*1e6, y*1e6, ang);
axis image;
xlabel('um');
ylabel('um');
title('Phase');

set(gcf,'units','normalized','outerposition',[0 0 1 1])
drawnow;

