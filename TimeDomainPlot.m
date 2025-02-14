function [] = TimeDomainPlot(signal, Fs, M, bitrate, rolloff)
   
    symbolrate = bitrate / log2(M);  
    bp = 1 / bitrate;  
    N = length(signal);  
    f = 2 * bitrate;  

    t = (0:N) * 100 / Fs;  

    zoom_range = [0, min(0.005, max(t))];

    x = real(signal);

    A = abs(signal);

    figure;
    ax1 = subplot(3, 1, 1);  
    ax2 = subplot(3, 1, 2);  
    ax3 = subplot(3, 1, 3);  

    hold(ax1, 'on');
    stem(ax1, (0:length(x)-1) *bp , real(signal), 'b', 'LineWidth', 1.2);  
    stem(ax1, (0:length(x)-1) *bp , imag(signal), 'r', 'LineWidth', 1.2); 
    title(ax1, 'Real and Imaginary Parts of Modulated Signal');
    xlabel(ax1, 'Time (seconds)');
    ylabel(ax1, 'Amplitude');
    legend(ax1, 'Real Part', 'Imaginary Part');
    xlim(ax1, zoom_range);
    grid(ax1, 'on');
    hold(ax1, 'off');

    phaseDeviation = angle(signal);

    t2 = (0:bp/99:bp)';  
    timeMatrix = repmat(t2, 1, length(x)); 
    phaseMatrix = repmat(phaseDeviation, length(t2), 1);  

    modulatedCarrier = A .* sin(2 * pi * f * timeMatrix + phaseMatrix);
    modulatedCarrier = modulatedCarrier(:)';  

    t3 = (0:length(modulatedCarrier)-1) * bp/100 ;

    plot(ax2, t3, modulatedCarrier, 'r', 'LineWidth', 1.2);
    title(ax2, 'PSK Modulated Carrier Using Phase Deviation');
    xlabel(ax2, 'Time (seconds)');
    ylabel(ax2, 'Amplitude');
    xlim(ax2, zoom_range);
    grid(ax2, 'on');

  
    rcos_filter = rcosdesign(rolloff, 6, Fs / symbolrate, 'sqrt');
    filtered_carrier = filter(rcos_filter, 1, modulatedCarrier);


    plot(ax3, t3, filtered_carrier, 'b', 'LineWidth', 1.2);
    title(ax3, 'Filtered Modulated Carrier with Phase Deviations');
    xlabel(ax3, 'Time (seconds)');
    ylabel(ax3, 'Amplitude');
    xlim(ax3, zoom_range);

    linkaxes([ax1, ax2, ax3], 'x');

end
   
