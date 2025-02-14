%% this file can be changed for alternative data point generations.

function [data] = MessageGenerator(M, numSymbols)
    data = randi([0 M-1], 1, numSymbols); 
end

