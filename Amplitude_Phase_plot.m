%% amplitude and phase of the modulated signal
function [] = Amplitude_Phase_plot(modulated, modulated_noisy, Fs)
    
    N = length(modulated);
    t = (0:N-1)/Fs ;
  
    figure;
    
    % Plot real part of the signals
    subplot(2, 1, 1);
    plot(t, abs(modulated), 'b', 'LineWidth', 1.2);
    hold on;
    plot(t, abs(modulated_noisy), 'r', 'LineWidth', 1);
    title('Amplitude Part of Modulated Signal');
    xlabel('Sample Index');
    ylabel('Amplitude');
    legend('Clean Signal', 'Noisy Signal');
    grid on;

    % Plot imaginary part of the signals
    subplot(2, 1, 2);
    plot(t, rad2deg(atan2(imag(modulated),real(modulated))), 'b', 'LineWidth', 1.2);
    hold on;
    plot(t, rad2deg(atan2(imag(modulated_noisy),real(modulated_noisy))), 'r', 'LineWidth', 1);
    title('Phase Part of Modulated Signal');
    xlabel('Sample Index');
    ylabel('Phase');
    legend('Clean Signal', 'Noisy Signal');
    grid on;
end
