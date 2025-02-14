%% a function to transform modulated signal to fmodulated it also configures the domain of F.
function [fmodulated, f] = Ftransform(modulated_shaped, Fs)

N = length(modulated_shaped);    
fft_signal = fft(modulated_shaped, N); 
f = (-Fs/2):(Fs/N):(Fs/2 - Fs/N);    

fmodulated = fftshift(fft_signal); 



