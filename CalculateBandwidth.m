function bw_main_lobe = CalculateBandwidth(modulated_signal, Fs)

    N = length(modulated_signal);
    f = (-Fs/2):(Fs/N):(Fs/2 - Fs/N);

    spectrum = fftshift(fft(modulated_signal, N));
    power_spectrum = abs(spectrum).^2;
    normalized_power = power_spectrum / sum(power_spectrum);
    cumulative_power = cumsum(normalized_power);

    lower_idx = find(cumulative_power >= 0.0002, 1);
    upper_idx = find(cumulative_power >= 0.9998, 1); 

    if isempty(lower_idx) || isempty(upper_idx)
        warning('Could not find significant main lobe bounds.');
        bw_main_lobe = 0;
    else
        bw_main_lobe = abs(f(upper_idx) - f(lower_idx));
    end
end
