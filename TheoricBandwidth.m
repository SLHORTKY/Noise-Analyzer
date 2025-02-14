function [fupper, flower] = TheoricBandwidth(symbol_rate, rolloff)
    % Calculate theoretical bandwidth for raised cosine filter
    BW = (1 + rolloff) * symbol_rate;  % Total bandwidth
    
    flower = -BW / 2;  % Lower frequency bound (negative)
    fupper = BW / 2;   % Upper frequency bound (positive)
end
