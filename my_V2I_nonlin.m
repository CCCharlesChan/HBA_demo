function [ I ] = my_V2I_nonlin( V, Diode, Iphoton )
%Compute current response of the nonlinear circuit driver
%   Input: V - Nx1 vector, voltage waveform at the port of the circuit
%   driver; Diode - dark IV curve of the photodiode that drives the
%   circuit; Iphoton - Nx1 vector, photocurrent induced by the pulsed
%   laser illumination.
%   Output: I - current output of the circuit driver.
I = -interp1(Diode.V, Diode.I, V, 'linear', 'extrap'); %p->n current under forward bias 
I = I + Iphoton; %total current output
end

