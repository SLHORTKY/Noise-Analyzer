% Given Parameters
Fs = 20000;               % Sampling frequency in Hz
N = 200;                  % Number of samples
t = (0:N-1) / Fs;         % Time vector
fc = 2000;                % Signal frequency

% Define Original Signal
signal = cos(2*pi*fc*t);  % Cosine signal

% Fourier Transform for Visualization
signal_fft = fftshift(fft(signal));
f = linspace(-Fs/2, Fs/2, length(signal_fft));

% Design Filters
lp_filter = designfilt('lowpassiir', 'FilterOrder', 8, ...
                        'PassbandFrequency', 1500, 'PassbandRipple', 0.5, 'SampleRate', Fs);

hp_filter = designfilt('highpassiir', 'FilterOrder', 8, ...
                        'PassbandFrequency', 2500, 'PassbandRipple', 0.5, 'SampleRate', Fs);

bp_filter = designfilt('bandpassiir', 'FilterOrder', 8, ...
                        'HalfPowerFrequency1', 1000, 'HalfPowerFrequency2', 3000, 'SampleRate', Fs);

% Apply Filters
signal_lp = filter(lp_filter, signal);
signal_hp = filter(hp_filter, signal);
signal_bp = filter(bp_filter, signal);

% Plot Time and Frequency Domain Results
figure;

% Time Domain Plots
subplot(3, 2, 1);
plot(t, signal_lp, 'LineWidth', 1.5);
title('Low-Pass Filtered Signal');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3, 2, 3);
plot(t, signal_hp, 'LineWidth', 1.5);
title('High-Pass Filtered Signal');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3, 2, 5);
plot(t, signal_bp, 'LineWidth', 1.5);
title('Band-Pass Filtered Signal');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

% Frequency Domain Plots
subplot(3, 2, 2);
plot(f, abs(fftshift(fft(signal_lp))), 'LineWidth', 1.5);
title('LPF Frequency Response');
xlabel('Frequency (Hz)'); ylabel('Magnitude'); grid on;

subplot(3, 2, 4);
plot(f, abs(fftshift(fft(signal_hp))), 'LineWidth', 1.5);
title('HPF Frequency Response');
xlabel('Frequency (Hz)'); ylabel('Magnitude'); grid on;

subplot(3, 2, 6);
plot(f, abs(fftshift(fft(signal_bp))), 'LineWidth', 1.5);
title('BPF Frequency Response');
xlabel('Frequency (Hz)'); ylabel('Magnitude'); grid on;
