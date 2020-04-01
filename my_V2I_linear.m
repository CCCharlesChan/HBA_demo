function [ I ] = my_V2I_linear(V, Z)
%Compute current response of the linear electrode
%   Input: V - Nx1 vector, periodic voltage waveform of the
%   electrode-electrolyte interface; Z - Nx1 vector, impedance spectrum of
%   the interface, impedances at f = (0:N-1)/N/T.
%   Output: I - Nx1 vector, the calculated current response.
V_hat = fft(V); %Fast Fourier transform (FFT) to frequency domain
I_hat = V_hat./conj(Z); %Apply the impedance spectrum
I = real(ifft(I_hat)); %Inverse FFT back to time domain
end

