function [ I ] = my_V2I_linear(V, Z)
%Calculate voltage waveform from current waveform
V_hat = fft(V);
I_hat = V_hat./conj(Z);
I = real(ifft(I_hat));
end

