%% for now it only adds a single carrier however this function can be modified to add multi spur carriers with
%% spesific frequency shifts
function [spurSignal, totalPower] = InBandSpur(Amp, fo, f0s, Fs, N)
    t = (0:N - 1) / Fs; 
    spurSignal = zeros(1, N);
    
    for i = 1:length(f0s)
        spurSignal = spurSignal + Amp(i) * exp(1j * 2 * pi * (f0s(i) + fo) * t);
    end

    totalPower = mean(abs(spurSignal).^2);
end
