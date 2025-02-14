bitrate = 1000;  
M = 2;
symbolRate = bitrate / log2(M);    
Fs = symbolRate * 6;

sps = Fs / symbolRate;   
span = 6;                
rollOff = 0.35;          

rcFilter = rcosdesign(rollOff, span, sps, 'normal');

numSymbols = 1000;
%dataSymbols = 2 * randi([0 1], 1, numSymbols) - 1;  % BPSK data (±1)

data = randi([0,M-1],1,numSymbols);
dataSymbols = pskmod(data,M);

upsampledData = upsample(dataSymbols, sps);

shapedSignal = filter(rcFilter, 1, upsampledData);

N = length(shapedSignal);

t = (0:length(shapedSignal) - 1) / Fs;
f = (-Fs/2):(Fs/N):(Fs/2 - Fs/N);  

basebandFFT = fftshift(fft(upsampledData, N));
shapedFFT = fftshift(fft(shapedSignal, N));

figure;
subplot(3, 1, 1);
stem((0:numSymbols-1)/symbolRate, dataSymbols, 'filled');
title('Original BPSK Symbols');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 2);
plot(t, shapedSignal, 'LineWidth', 1.5);
title('Raised Cosine Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 3);
plot(f, abs(basebandFFT), 'r', 'LineWidth', 1.2);
hold on;
plot(f, abs(shapedFFT), 'b', 'LineWidth', 1.2);
title('Spectrum: Baseband vs Raised Cosine Shaped');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Baseband Signal', 'Shaped Signal');
grid on;
