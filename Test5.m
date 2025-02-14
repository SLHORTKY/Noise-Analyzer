% Example values for the function
Amp = [2];   % Amplitudes of each spur
f0s = [100];  % Frequency shifts of each spur (in Hz)
Fs = 1000;              % Sampling frequency (in Hz)
N = 1000;               % Number of samples

% Call the function
[spurSignal, totalPower] = InBandSpur(Amp, f0s, Fs, N);

% Display the total power of the spur signal
disp(['Total power of the spur signal: ', num2str(totalPower)]);

function [spurSignal, totalPower] = InBandSpur(Amp, f0s, Fs, N)
    % Amp: vector of amplitudes for each spur
    % f0s: vector of frequency shifts for each spur
    % Fs: Sampling frequency
    % N: Number of samples
    
    t = (0:N - 1) / Fs;  % Time vector
    spurSignal = zeros(1, N);  % Initialize the spur signal
    
    % Add each spur carrier to the signal
    for i = 1:length(f0s)
        spurSignal = spurSignal + Amp(i) * exp(1j * 2 * pi * f0s(i) * t);
    end
    
    % Calculate total power of the spur signal
    totalPower = mean(abs(spurSignal).^2);
end
