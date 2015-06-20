% Simulate and plot BER for each mode
% Set payload error meter to stop simulation after 100 errors
% Turn off instrumentation 

% Clear results
clear results;

% Define model
modelname='WiFi';

% Turn on AWGN
set_param([modelname '/System Parameters'],'Channel_type','AWGN')

% Set EsNo variable
set_param([modelname '/System Parameters'],'EsNo','EsNo')

% Modes to test
Modes={'1Mbps','2Mbps','5.5Mbps','11Mbps'};

% EsNo range to test
var_list = -14:3:-2;

% Set Preamble long
set_param([modelname '/System Parameters'],'Short_preamble','off');
    
for Mode=1:length(Modes)
    disp(['Testing Mode: ' Modes{Mode}])
    set_param([modelname '/System Parameters'],'Mode',Modes{Mode})
    for i = 1:length(var_list)
        EsNo = var_list(i);
        disp(['EsNo=' num2str(EsNo)])
        sim(modelname) % Run until 100 errors
        results(i,Mode) = BER(3);
    end
end
    
% Plot results
semilogy(var_list,fliplr(results),'*-'); grid;
title('BER v Es/No');
xlabel('Es/No');
ylabel('BER');
legend(char(fliplr(Modes)));



