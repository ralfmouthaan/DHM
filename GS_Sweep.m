% Ralf Mouthaan
% University of Adelaide
% May 2024

clc; clear variables; close all;
addpath('Functions/')

%% Pre-processing

lambda = 532e-9;
NA = 0.5;
arrz = [-500 -450 -400 -350 -300 -250 -200 -180 -160 -140 -120 -100 ...
    -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100 ...
    120 140 160 180 200 250 300 350 400 450 500];

for idxz = 1:length(arrz)

    H = double(imread(['Data/On Axis - z=' num2str(arrz(idxz)) '.png']));
    Ref = double(imread("Data/Reference.png"));
    Mask = imread("Data/Mask.png");
    Mask = double(rgb2gray(Mask))/255;
    Mask = imgaussfilt(Mask, 20);
    
    H = H./Ref;
    
    H = sqrt(H);
    
    Nx = size(H, 2);
    Ny = size(H, 1);
    
    dx = 2.4e-6/20*200/150;
    x = (0:Nx-1)*dx;
    y = (0:Ny-1)*dx;
    x2 = (0:2*Nx-1)*dx;
    y2 = (0:2*Ny-1)*dx;
    
    z=arrz(idxz)*1e-6;
    
    K = ASMKernel(x, y, z, lambda);
    NAKernel = NAFilter(x, y, NA, lambda);
    K = K.*NAKernel;
    
    %% Gerchberg-Saxton
    
    F = H;
    
    for ii = 1:100
    
        disp(ii);
    
        F = Conv2_FFT(F, conj(K));
        %F(abs(F) > 1) = exp(1i*angle(F(abs(F) > 1)));
        F = exp(1i*angle(F));
        F = abs(F);
        F = F.*Mask + (1-Mask);
        F = Conv2_FFT(F, K);
        F = H.*exp(1i*angle(F));
    
    end
    
    % Final propagation back to object plane
    F = Conv2_FFT(F, conj(K));
    
    %% Show Result
    
    h = figure;
    imagesc(x*1e6, y*1e6, abs(F));
    axis image;
    xlabel('um');
    ylabel('um');
    title('Mag');

    saveas(h, ['Results/z = ' num2str(arrz(idxz)) ' - Mag.png'])
    
    ang = angle(F);
    ang = Unwrap(ang);
    
    h = figure;
    imagesc(x*1e6, y*1e6, ang);
    axis image;
    xlabel('um');
    ylabel('um');
    title('Phase');

    saveas(h, ['Results/z = ' num2str(arrz(idxz)) ' - Phase.png'])

end


