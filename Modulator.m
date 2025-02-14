function modulated = Modulator(data, Fs, M, modulation_type, amplitude)
    switch upper(modulation_type)
        case 'PSK' % Phase Shift Keying (BPSK, QPSK, etc.)
            modulated_baseband = pskmod(data, M, 0, 'gray');

        case 'QAM' % Quadrature Amplitude Modulation (16-QAM, 64-QAM, etc.)
            modulated_baseband = qammod(data, M, 'gray');
        case 'FSK' % Frequency Shift Keying (2-FSK, 4-FSK, etc.)
            freqsep = Fs / M; % Frequency separation (Hz)
            nsamp = 30;      % Number of samples per symbol
            modulated_baseband = fskmod(data, M, freqsep, nsamp, Fs, 'cont', 'gray');

        case 'DPSK' % Differential Phase Shift Keying (DBPSK, DQPSK)
            modulated_baseband = dpskmod(data, M);

        case 'APSK' % Amplitude Phase Shift Keying (APSK)
            if M <= 4
                modulated_baseband = qammod(data, M, 'gray');
            else
                [bands, Amplitude_levels] = NumberofBands(M, 4);
                modulated_baseband = apskmod(data, bands, Amplitude_levels);
            end

        otherwise
            error('Unsupported modulation type. Choose from PSK, QAM, FSK, APSK, DPSK, MSK, OFDM.');
    end

    modulated = amplitude .* modulated_baseband;
end
