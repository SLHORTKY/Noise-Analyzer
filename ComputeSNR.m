%% if the SNR calculation is mistaken this is the file that calculates it.

function [SNR_dB] = ComputeSNR(modulated, modulated_noisy , in_band_spur_power)

    P_signal = mean(abs(modulated).^2);

    amp_modulated = abs(modulated);
    phase_modulated = angle(modulated);

    amp_noisy = abs(modulated_noisy);
    phase_noisy = angle(modulated_noisy);

    noise_amplitude = amp_noisy - amp_modulated;
    noise_phase = phase_noisy - phase_modulated;

    noise = noise_amplitude .* exp(-1j * noise_phase);

    P_noise = mean(abs(noise).^2) + in_band_spur_power;

    SNR_dB = 10 * log10(P_signal / P_noise);
       
end

