clc;
clear;
close all;

% Parameters
M = 4;  % BPSK modulation order
n = 8;                  % Number of bits
x = randi([0, M-1], 1, n); % Random bit generator
bp = 1e-6;              % Bit period
disp('Binary information at Transmitter:');
disp(x);

t1 = (1:length(x)) * bp;
subplot(4, 1, 1);
stem(t1, x, 'LineWidth', 2.5); grid on;

ylabel('Amplitude (volts)');
xlabel('Time (sec)');
title('Binary data in the form of a digital signal');

% PSK Modulation using built-in pskmod

modulatedSymbols = pskmod(x, M, pi);  % PSK-modulated data with 0/π phases

% Extract phase deviation
phaseDeviation = angle(modulatedSymbols);  % Phase deviation from PSK

% Generate carrier-modulated signal
A = 5;                       % Carrier amplitude
br = 1 / bp;                 % Bit rate
f = br * 2;                  % Carrier frequency
t2 = (bp / 99:bp / 99:bp)';  % Time vector for one bit (column vector)

% Create a time matrix where each column corresponds to a bit period
timeMatrix = repmat(t2, 1, length(x));

% Create a phase matrix corresponding to each bit
phaseMatrix = repmat(phaseDeviation, length(t2), 1);

% Generate modulated carrier signal in a single operation
modulatedCarrier = A * sin(2 * pi * f * timeMatrix + phaseMatrix);

% Flatten the matrix into a row vector
modulatedCarrier = modulatedCarrier(:)';

% Time vector for the entire modulated signal
t3 = bp / 99:bp / 99:bp * length(x);

% Plot carrier signal
subplot(4, 1, 2);
carrierSignal = A * sin(2 * pi * f * t3);
plot(t3, carrierSignal); grid on;
xlabel('Time (sec)');
ylabel('Amplitude (volt)');
title('Carrier Signal');

% Plot PSK-modulated signal
subplot(4, 1, 3);
plot(t3, modulatedCarrier, 'LineWidth', 1.2); grid on;
xlabel('Time (sec)');
ylabel('Amplitude (volt)');
title('PSK Modulated Carrier Using Phase Deviation');

% Demodulation
demodulatedBits = pskdemod(modulatedSymbols, M, pi);
disp('Binary data at Receiver:');
disp(demodulatedBits);

