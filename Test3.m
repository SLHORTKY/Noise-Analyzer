% Set up 
% Specified parameters
M = 2;        % Modulation order (BPSK)
nData = 1000; % Number of bits
Fc = 100;     % Carrier frequency, Hz

% Assumed parameters
Fb = 100;      % Bit (baud) rate, bps
Fs = 8*Fc;     % Sampling frequency, Hz
Ts = 1/Fs;     % Sample time, sec
Td = nData/Fb; % Time duration, sec
spb = Fs/Fb;   % Samples per bit
fSpan = 4;     % Filter span in symbols

% Visualize the spectrum of baseband BPSK & modulated carrier
specAn1 = dsp.SpectrumAnalyzer("SampleRate", Fs, "Method","Filter bank","AveragingMethod","Exponential","Title", "Pulse Shaped Baseband BPSK");
specAn2 = dsp.SpectrumAnalyzer("SampleRate", Fs, "Method","Filter bank","AveragingMethod","Exponential","Title", "BPSK Modulated Carrier");

% Transmitter
% Generate random data bits
data = randi([0 M-1],nData,1);
% Modulate and plot the data
% pskmod() effectively converts unipolar to bipolar bits and performs BPSK
% modulation
modData = real(pskmod(data,M));
% Pulse shape & upsample to match carrier's sampling rate. Pulse shaping is
% used to reduce intersymbol interference and to reduce spectral width of
% the modulated signal.
txFilter = comm.RaisedCosineTransmitFilter("FilterSpanInSymbols",fSpan,"OutputSamplesPerSymbol",spb);
txfilterOut = txFilter(modData);
specAn1(txfilterOut);