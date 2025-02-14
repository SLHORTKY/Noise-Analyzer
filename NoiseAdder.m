%% a function to add amplitude and phase noise to the modulation dont change this file.

function [modulated_noisy] = NoiseAdder(modulated,mean_amp,std_amp,mean_phase,std_phase,amplitude);
    rng(42);

    N = length(modulated);

    normalization_factor = 0.2;
    noise_amp = mean_amp + (std_amp * normalization_factor) * randn(1, N);

    mean_phase_radians = deg2rad(mean_phase);
    std_phase_radians = deg2rad(std_phase);

    noise_phase = mean_phase_radians + (std_phase_radians * normalization_factor ) * randn(1, N);
    noise_phase = mod(noise_phase, 2 * pi);
    
    modulated_noisy = modulated .* (1 + noise_amp / amplitude) .* exp(1j * noise_phase);
end

