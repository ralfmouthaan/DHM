% Ralf Mouthaan
% University of Adelaide
% February 2024
%
% Script to calculate lens kernel

function K = NAFilter(x, y, NA, lambda)

    % Coord calculations
    Nx = length(x);
    Ny = length(y);
    dx = x(2) - x(1);
    dy = x(2) - x(1);
    kx = linspace(-1/dx/2, 1/dx/2, Nx); % Do I need a factor of 2pi in here?
    ky = linspace(-1/dy/2, 1/dy/2, Ny);
    kr = sqrt(kx.^2 + ky.'.^2);

    % Kernel calculation
    K = ones(Ny, Nx);
    K(kr > NA/lambda) = 0;

end