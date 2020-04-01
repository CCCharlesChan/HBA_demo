function [ I ] = my_V2I_nonlin( V, Diode, Iphoton )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
I = -interp1(Diode.V, Diode.I, V, 'linear', 'extrap');
I = I + Iphoton;
end

