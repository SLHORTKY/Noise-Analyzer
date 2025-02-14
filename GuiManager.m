function GuiManager()
    
    M = 2;
    numSymbols = 5000; % number of symbols resolution.
    bitRate = 1000; % bitrate;

    Fs = bitRate / log2(M) * 2; %% determines the frame size

    spur_Frequency = [0];

    data = MessageGenerator(M, numSymbols);
    
    amplitude = 1.0; 

    inbandspur = false;
    spurAmplitude = 0.0;
    slidable_frequency = 0.0;

    % design configurations
    panel_width = 220;
    panel_height = 400;
    label_width = 150;
    slider_width = 150;
    panel_figure_gap = 30;

    figure_width = 700;
    figure_height = 340;

    rolloff = 0.0;
    SNR_dB = 0.0;
    B_filtered = 0.0;

    fig = uifigure('Name', 'Noise Effect Analyzer', 'Position', [100, 100, 1000, 700]);

    SNRLABEL = uilabel(fig, ...
                   'Text', sprintf('SNR: %.2f dB', SNR_dB), ...
                   'Position', [800, 10, label_width, 20]);

    rolloffLABEL = uilabel(fig, ...
                   'Text', sprintf('SNR: %.2f dB', SNR_dB), ...
                   'Position', [700, 10, label_width, 20]);

    BWLABEL = uilabel(fig, ...
                         'Text', sprintf('Bandwidth: %.2f Hz', B_filtered), ...
                         'Position', [900, 10, label_width, 20]);

    modulator_panel = uipanel(fig, 'Title', 'Modulation settings', ...
                              'Position', [10, 400, panel_width, panel_height-100]);

    dropdown = uidropdown(modulator_panel, ...
                          'Position', [15, 240, 70, 22], ...
                          'Items', {'PSK','QAM','FSK','APSK','DPSK'}, ...
                          'Value', 'PSK', ... % Default selected value
                          'ValueChangedFcn', @dropdownCallback); 

    M_dropdown = uidropdown(modulator_panel, ...
                          'Position', [15, 210, 120, 22], ...
                          'Items', {'2','4','8','16','32'}, ...
                          'Value', '2', ... % Default selected value
                          'ValueChangedFcn', @M_dropdownCallback); % Callback function

    sliderPanel = uipanel(fig, 'Title', 'AWGN parameters', ...
                          'Position', [10, 10, panel_width, panel_height]);

    ANoise_slider_Panel = uipanel(sliderPanel, 'Title', 'Amplitude distortion', ...
                          'Position', [15, panel_height/2, panel_width-30, panel_height/2 - 30]);

    PNoise_slider_Panel = uipanel(sliderPanel, 'Title', 'Phase distortion (degrees)', ...
                          'Position', [15, 10, panel_width-30, panel_height/2 - 30]);

    Spur_slider_Panel =  uipanel(modulator_panel, 'Title', 'In Band Spur', ...
                          'Position', [15, 15, panel_width-30, panel_height/3 + 15]);

    slider_range = bitRate / log2(M);

    Spur_frequency_slider = uislider(Spur_slider_Panel, ...
                           'Position', [20, 40, slider_width, 3], ...
                           'Limits', [-slider_range, slider_range], ...
                           'Value', 0, ...
                           'ValueChangedFcn', @Spur_slider_callback);

    Spur_amplitude_slider = uislider(Spur_slider_Panel, ...
                           'Position', [20, 80, slider_width, 3], ...
                           'Limits', [0, 5], ...
                           'Value', 0, ...
                           'ValueChangedFcn', @Spur_slider_callback);

    spur_active = uicontrol( Spur_slider_Panel, ...
                            'Style', 'checkbox', ...
                            'String', 'Add Spur', ...
                            'Position', [15, 100, 120, 30], ...
                            'Value', 0, ...
                            'Callback', @checkboxCallback);

    
    plot_btn = uicontrol(modulator_panel ,'Style', 'pushbutton', 'String', 'Plot', ...
                'Position', [90, 240, 50, 22], ... % [x, y, width, height]
                'Callback', @button_callback); % The callback function

    meanLabel_amp = uilabel(ANoise_slider_Panel, ...
                        'Text', 'Mean', ...
                        'Position', [20, 120, label_width, 20]); 

    mean_slider_amp = uislider(ANoise_slider_Panel, ...
                           'Position', [20, 110, slider_width, 3], ...
                           'Limits', [0, 5], ...
                           'Value', 0, ...
                           'ValueChangedFcn', @slider_callback);

    stdDevLabel_amp = uilabel(ANoise_slider_Panel, ...
                          'Text', 'Standard Deviation', ...
                          'Position', [20, 60, label_width, 20]); % Above the slider

    std_slider_amp = uislider(ANoise_slider_Panel, ...
                          'Position', [20, 50 , slider_width, 3], ...
                          'Limits', [0, 5], ...
                          'Value', 0, ...
                          'ValueChangedFcn', @slider_callback);

    meanLabel_ph = uilabel(PNoise_slider_Panel, ...
                        'Text', 'Mean', ...
                        'Position', [20, 120, label_width, 20]); % Above the slider

    mean_slider_ph = uislider(PNoise_slider_Panel, ...
                           'Position', [20, 110, slider_width, 3], ...
                           'Limits', [0, 60], ...
                           'Value', 0, ...
                           'ValueChangedFcn', @slider_callback);

    stdDevLabel_ph = uilabel(PNoise_slider_Panel, ...
                          'Text', 'Standard Deviation', ...
                          'Position', [20, 60, label_width, 20]); % Above the slider

    std_slider_ph = uislider(PNoise_slider_Panel, ...
                          'Position', [20, 50 , slider_width, 3], ...
                          'Limits', [0, 180], ...
                          'Value', 0, ...
                          'ValueChangedFcn', @slider_callback);


    uicontrol(modulator_panel,'Style', 'text', 'Position', [20, 180, 40, 22], 'String', 'Bitrate:');
    BitrateinputBox = uicontrol(modulator_panel,'Style', 'edit', 'Position', [60, 180, 70, 22], 'String', sprintf("%d",bitRate));
    bitrate_btn = uicontrol(modulator_panel ,'Style', 'pushbutton', 'String', 'update', ...
                'Position', [140, 180, 70, 22], ... 
                'Callback', @bitrate_button_callback); 

    uicontrol(modulator_panel,'Style', 'text', 'Position', [140, 240, 70, 22], 'String', 'SymbolNum:');
    SymbolNuminputBox = uicontrol(modulator_panel,'Style', 'edit', 'Position', [140, 210, 70, 22], 'String', sprintf("%d",numSymbols));


  
    ax1 = uiaxes(fig, 'Position', [200 + panel_figure_gap, 360, figure_width, figure_height]);
    title(ax1, 'Constellation');
    grid(ax1, 'on');  
    axis(ax1, 'equal');

    ax2 = uiaxes(fig, 'Position', [200 + panel_figure_gap, 30, figure_width, figure_height]);
    title(ax2, 'Spectrum');
    xlabel(ax2, 'frequency (Hz)');
    ylabel(ax2, 'Amplitude');
    grid(ax2, 'on');

    modulated = Modulator(data, Fs, M, dropdown.Value, amplitude);
    modulated_noisy = NoiseAdder(modulated, 0.0,0.0,0.0,0.0, amplitude);
    update_figures(modulated, modulated_noisy);

    function dropdownCallback(src, ~)
        update(data, M, true);
    end
    
    function M_dropdownCallback(src, ~)
        
        M = str2double(src.Value);  
        slider_range = Fs /( 2*log2(M));
        Spur_frequency_slider.Limits = [-slider_range slider_range];

        data = MessageGenerator(M, numSymbols);
        update(data, M, true);
    end

    function slider_callback(~, event)
        update(data,M,false);
    end

    function Spur_slider_callback(~ , event)

        slidable_frequency = Spur_frequency_slider.Value;
        spurAmplitude = Spur_amplitude_slider.Value;
        update_figures(modulated, modulated_noisy);
    end

    function button_callback(~, ~)
        TimeDomainPlot(modulated, Fs, M, bitRate, rolloff);
    end

    function bitrate_button_callback(~,~)
        % Get input values
        bitRateStr = get(BitrateinputBox, 'String');
        symbolNumberStr = get(SymbolNuminputBox, 'String');
        
        % Check if both fields are empty
        if isempty(bitRateStr) && isempty(symbolNumberStr)
            % If both fields are empty, do nothing and return
            disp('Both fields are empty, no update performed.');
            return;
        end
    
        % Convert to numbers only if the field is not empty
        if ~isempty(bitRateStr)
            bitRate = str2double(bitRateStr);
            if mod(bitRate, 1) ~= 0
                disp('Bit rate must be a valid integer.');
                return;  % Exit if bitRate is not an integer
            end
        else
            % If bitRate is empty, retain its previous value (assume it's already set)
            bitRate = NaN;  % Or use some default value if necessary
        end
    
        if ~isempty(symbolNumberStr)
            symbolNumber = str2double(symbolNumberStr);
            if mod(symbolNumber, 1) ~= 0
                disp('Symbol number must be a valid integer.');
                return;  % Exit if symbolNumber is not an integer
            end
        else
            symbolNumber = numSymbols; 
        end
   
        if ~isnan(bitRate) && ~isnan(symbolNumber)
            data = MessageGenerator(M, symbolNumber);
            Fs = bitRate  * 2;
            update(data, M, true);

        elseif ~isnan(bitRate)
            data = MessageGenerator(M, symbolNumber);
            update(data, M, true);
        elseif ~isnan(symbolNumber)
            Fs = bitRate  * 2;
            update(data, M, false);
        end
    end

    function checkboxCallback(src, ~)
        if src.Value
            inbandspur = true;
        else
            inbandspur = false;
        end
        update(data,M,false);
    end
    
    function update_figures(constellation_signal, modulated_noisy)

        [modulated_noisy_shaped, rolloff] = conditionallyShape(modulated_noisy);
        B_filtered = CalculateBandwidth(modulated_noisy_shaped, Fs);

        power = 0.0;
        if inbandspur
            [in_band_spur, power] = InBandSpur(spurAmplitude,slidable_frequency,spur_Frequency,Fs, length(modulated_noisy_shaped));
            modulated_noisy_shaped = modulated_noisy_shaped + in_band_spur;
            modulated_noisy_clone = modulated_noisy + InBandSpur(spurAmplitude, slidable_frequency, spur_Frequency,Fs, length(modulated_noisy));
        else
            modulated_noisy_clone = modulated_noisy;
        end
        
        
        
        SNR_dB = ComputeSNR(constellation_signal, modulated_noisy, power);
        SNRLABEL.Text = sprintf('SNR: %.2f dB', SNR_dB);

        rolloffLABEL.Text = sprintf('rolloff : %.2f', rolloff);

        [fmodulated_noisy, f] = Ftransform(modulated_noisy_shaped, Fs);
        
        plot(ax2, f, 20*log10(abs(fmodulated_noisy)), 'b', 'LineWidth', 1.5); 
        ax2.Title.String = 'Spectrum';

        if strcmp(dropdown.Value, 'FSK')
            B_filtered = Fs / M;
            
            modulated_noisy_1 = downsample(modulated_noisy_clone, 2);
            constellation_signal_1 = downsample(constellation_signal, 2);
           
            % Plot the noisy modulated signal (blue dots)
            scatter(ax1, real(modulated_noisy_1), imag(modulated_noisy_1), 150, 'b.');
            hold(ax1, 'on');
            
            % Plot the constellation signal (red Xs)
            scatter(ax1, real(constellation_signal_1), imag(constellation_signal_1), 100, 'rX','LineWidth', 1.5);  
            
            % Add legend for FSK
            legend(ax1, {'Noisy Signal', 'Noiseless Signal'}, 'Location', 'best');
            hold(ax1, 'off');
        else
            hold(ax2, 'on');
            
            % Calculate theoretical bandwidth and fill the region
            [fupper, flower] = TheoricBandwidth(bitRate / log2(M), rolloff);
            fill(ax2, [flower, flower, fupper, fupper], [-10, 20, 20, -10], 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            hold(ax2, 'off');
            
            % Plot the noisy modulated signal (blue dots)
            scatter(ax1, real(modulated_noisy_clone), imag(modulated_noisy_clone), 150, 'b.');
            hold(ax1, 'on');
            
            % Plot the constellation signal (red Xs)
            scatter(ax1, real(constellation_signal), imag(constellation_signal), 100, 'rX','LineWidth', 1.3);  
            
            % Add legend for the other modulation type
            legend(ax1, {'Noisy Signal', 'Noiseless Signal'}, 'Location', 'best');
            hold(ax1, 'off');
        end



        BWLABEL.Text = sprintf('BW: %.2f Hz', B_filtered);

        ax1.Title.String = 'Constellation Diagram';
        axis(ax1, 'equal');
        
    end
    
    function [modulated_shaped, rolloff ] = conditionallyShape(signal)

        if strcmp(dropdown.Value , "FSK")
            modulated_shaped = signal;
            rolloff = 0.0;
        else
            [modulated_shaped, rolloff] = ApplyPulseShaping(signal, bitRate, M ,Fs);
        end
    end

    function update(updatedData, M, remodulate)
        mean_amp = mean_slider_amp.Value; 
        std_amp = std_slider_amp.Value; 
        mean_phase = mean_slider_ph.Value; 
        std_phase = std_slider_ph.Value; 
        modulation_type = dropdown.Value;

        if(remodulate)
            modulated = Modulator(updatedData, Fs, M, modulation_type, amplitude);
        end

        modulated_noisy = NoiseAdder(modulated, mean_amp, std_amp, mean_phase, std_phase, amplitude);
        update_figures(modulated, modulated_noisy);
    end
end
