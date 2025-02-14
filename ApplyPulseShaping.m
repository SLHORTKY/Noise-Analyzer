function [modulated_shaped, rolloff, sps] = ApplyPulseShaping(modulated, bitrate, M, Fs)
    % Parameters
    symbol_rate = bitrate / log2(M);   
    sps = ceil(Fs / symbol_rate);     
    span = 8;                          
    
    switch M
        case {2, 4, 8}
            rolloff = 0.35;  
        case {16, 32, 64}
            rolloff = 0.25;  
        case {128, 256}
            rolloff = 0.2;  
        case 512
            rolloff = 0.15;  
        otherwise
            rolloff = 0.25;  
    end
    
    upsampled_signal = upsample(modulated, sps);
    
    rrc_filter = rcosdesign(rolloff, span, sps, 'sqrt');
    modulated_shaped = filter(rrc_filter, 1, upsampled_signal);
    %modulated_shaped = conv(upsampled_signal, rrc_filter, 'same');
   
end
