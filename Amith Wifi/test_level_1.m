% Test many combinations of parameters and ensure 0 BER for channel set to 'None'
% Paramters include of Mode, Channel number and size preamble
% Turn off instrumentation 

% Clear results
clear results;

% Define model
Modelname='WiFi';

% Time to run each simulation
Simulation_time=0.01;

% Set channel to 'None'
set_param([Modelname '/System Parameters'],'Channel_type','None')

% Define parameter set to test
Channel_numbers={'1' '6' '7' '11'};
Modes={'1Mbps','2Mbps','5.5Mbps','11Mbps'};
Preamble_options={'off', 'on'};

for Channel_num=1:length(Channel_numbers)
    
    set_param([Modelname '/System Parameters'],'Channel_number',Channel_numbers{Channel_num});
    disp(' ');
    disp(['Channel number = ' Channel_numbers{Channel_num} ]);
    
    % Test Mode 1
    Mode=1;
    set_param([Modelname '/System Parameters'],'Short_preamble','off');
    set_param([Modelname '/System Parameters'],'Mode',Modes{Mode}); % Set mode
    disp(['Testing Mode: ' Modes{Mode} '...']);
    
    sim(Modelname,Simulation_time); % Run simulation
    
    if any(BER)~=0 % Test for failure
        error(['Failed Mode ' Modes{Mode}]);
    end
    
    % Test remaining modes
    for Mode=2:length(Modes)
        
        set_param([Modelname '/System Parameters'],'Mode',Modes{Mode}); % Set mode
        for Preamble_option=1:length(Preamble_options) % For each preamble option
            
            disp(['Testing Mode: ' Modes{Mode} ', Short Preamble ' Preamble_options{Preamble_option} '...']);
            set_param([Modelname '/System Parameters'],'Short_preamble',Preamble_options{Preamble_option});
            sim(Modelname,Simulation_time); % Run simulation
            
            if any(BER)~=0 % Test for failure
                error(['Failed Mode ' Modes{Mode} ', Short Preamble ' Preamble_options{Preamble_option} ]);
            end 
        end
    end 
end

disp('Passed all tests')

