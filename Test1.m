M = 8;                
bitrate = 1000;         
symbol_rate = bitrate / log2(M);
Fs = 4 * symbol_rate;  
num_symbols = 10000;   
span = 6;             
rolloff = 0.35;       

bits = randi([0, 1], 1, num_symbols * log2(M));

symbols = bi2de(reshape(bits, log2(M), []).', 'left-msb');
psk_modulated = pskmod(symbols, M, 0, 'gray');

sps = Fs / symbol_rate;  
upsampled_signal = upsample(psk_modulated,sps);

rrc_filter = rcosdesign(rolloff, span, sps, 'sqrt');
shaped_signal = filter(rrc_filter, 1, upsampled_signal);

Bandwith = CalculateBandwidth(shaped_signal,Fs);


N = length(shaped_signal);
f_axis = (-Fs/2):(Fs/N):(Fs/2 - Fs/N);
power_spectrum = abs(fftshift(fft(shaped_signal, N))).^2;


figure;
plot(f_axis, 10 * log10(power_spectrum));
xlabel('Frequency ');
ylabel('Power Spectrum (dB)');
title(['Spectrum of PSK Modulated Signal (M = ' num2str(M) ')']);
grid on;

bw_theoretical = (1 + rolloff) * symbol_rate;

hold on;
bw_start = -bw_theoretical / 2 ;
bw_end = bw_theoretical / 2 ;
fill([bw_start, bw_start, bw_end, bw_end], [-100, 10, 10, -100], ...
     'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
legend('Power Spectrum', 'Theoretical Bandwidth');



