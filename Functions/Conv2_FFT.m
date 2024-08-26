% Ralf Mouthaan
% University of Adelaide
% February 2024
%
% The conv2 function seems to just hang with these inputs, but using our
% own FFT implementation seems to work.

function Fz = Conv2_FFT(F, K)

    invF = fftshift(fft2(fftshift(F)));
    Fz = ifftshift(ifft2(ifftshift(invF.*K)));

end