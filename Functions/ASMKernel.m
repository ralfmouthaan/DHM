% Ralf Mouthaan
% University of Adelaide
% February 2024
%
% Script to calculate ASM kernel

function K = ASMKernel(x, y, z, lambda)

    % Coord calculations
    Nx = length(x);
    Ny = length(y);
    dx = x(2) - x(1);
    dy = x(2) - x(1);
    kx = linspace(-1/dx/2, 1/dx/2, Nx); % Do I need a factor of 2pi in here?
    ky = linspace(-1/dy/2, 1/dy/2, Ny);
    kr = sqrt(kx.^2 + ky.'.^2);

    % Kernel calculation
    K = exp(1i*2*pi*abs(z)*sqrt(1/lambda^2 - kr.^2));

    if z < 0
        K = conj(K);
    end

end