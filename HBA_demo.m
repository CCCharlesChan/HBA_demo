clear all; close all; clc
load('data_demo.mat'); %including measurements of the dark IV curve of the
% photodiode, electrochemical impedance spectrocopy of the electrode and
% the current and voltage recordings in pulsing.
Rm = 5.1E3; %the monitor resistor in Ohm

%% Construct the impedance spectrum from EIS data
t = Pulsing.t; %ms
N = length(t); 
f = (1:N/2) / Pulsing.period *1E3; %Hz
Z = interp1(Electrode.f, Electrode.Z, f, 'pchip')'; %interpolate the relevant frequency points
Z = [Electrode.Rdc; Z; conj( Z(end-1:-1:1) )] + Rm; %construct the spectrum with legitimate phase 

%% Construct the illumination scheme
idx_lightON = (t>=Pulsing.t1) & (t<Pulsing.t2); %laser on between t1 and t2
Iphoton = -Pulsing.Irev * ones(N, 1); %the OFF current between pulses
Iphoton(idx_lightON) = Pulsing.Iphoton; %the ON current

%% Set up optimization
V_ini = .5*ones(N,1); %the initial voltage waveform, as the starting point for the optimization 
I_diff = @(V) ( my_V2I_linear(V, Z) - my_V2I_nonlin(V, Diode, Iphoton) ); % current difference between the linear and the nonlinear parts
I_norm = norm(I_diff(V_ini)) / sqrt(N); %scaling factor
F_target = @(V) I_diff(V) / I_norm;   %the actual target function is scaled to be in the computationally reasonable range

lb = -0.1* ones(N, 1); %upper bound for the optimization
ub = 0.9 * ones(N, 1); %lower bound for the optimization

%% Use optimization to find the voltage and current responses
[V, resnorm, residual, exitflag, output] = lsqnonlin(F_target, V_ini, lb, ub); %use optimization to find the voltage response
I = my_V2I_linear(V, Z); %the corresponding current response

%% Visualize the result
figure
plot(t(1:400), Pulsing.I(1:400), 'k'); hold on %measurement
plot(t(1:400), I(1:400), 'r'); %HBA current response