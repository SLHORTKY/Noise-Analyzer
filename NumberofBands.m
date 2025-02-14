%% a function to manage multiband configuration of APSK
%% it divides total M stars to n bands with m stars in each.
%% dont change unless you want to redistribute the constellations for APSK modulation

function [bands, Amplitude_levels] = NumberofBands(M, start)
    if mod(start, 4) ~= 0
        error('The start value must be a multiple of 4.');
    end
    bands = []; 
    Amplitude_levels = []; 

    remaining_electrons = M - start; 
    bands = [start]; 

    shell_number = 1; 
    while remaining_electrons > 0
        shell_number = shell_number + 1;
        max_electrons_in_shell = 4 * floor((2 * (shell_number^2)) / 4);
        if remaining_electrons < max_electrons_in_shell
            electrons_in_shell = 4 * floor(remaining_electrons / 4);
        else
            electrons_in_shell = max_electrons_in_shell;
        end
       
        bands = [bands, electrons_in_shell];
        remaining_electrons = remaining_electrons - electrons_in_shell;
    end

    Amplitude_levels = 1:shell_number;
    total_electrons = sum(bands);
    if total_electrons ~= M
        error('The total number of electrons does not add up to M.');
    end
end
