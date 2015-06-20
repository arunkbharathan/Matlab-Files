% Model Init

% Param checking
if (Packet_size>4095) || (Packet_size<1)
    errordlg('Packet size must be between 1 and 4095 bytes');
end

if (Short_preamble && (Mode==1))
    errordlg('Short Preamble cannot be used with 1Mbps rate');
end

% Model name
Modelname=bdroot;

% System variables (could be in preloaded)

evalin('base','Channel_size=55000;');
%assignin('base','Channel_size',55000);

evalin('base','Samples_per_chips=8;');
evalin('base','Filter_order=2*42;');
evalin('base','Spreading_rate=11;');
evalin('base','Chip_rate=11e6;');

% Calculate filter samples delay and correction delay for syncing to chips
Samples_per_chip=evalin('base','Samples_per_chips');
Filter_order=evalin('base','Filter_order');
Filter_delay_samples=Filter_order;
Filter_delay_chips=ceil(Filter_delay_samples/Samples_per_chip);
Filter_delay_samples_correction=(Samples_per_chip-rem(Filter_delay_samples,Samples_per_chip));
if (Filter_delay_samples_correction==Samples_per_chip)
    Filter_delay_samples_correction=0;  %Ignore if mulitple of Num samples
end
assignin('base','Filter_delay_samples_correction',Filter_delay_samples_correction);

% Calculate filter chips delay and correction delay for syncing to symbols
Spreading_rate=evalin('base','Spreading_rate');
Filter_delay_symbols=ceil(Filter_delay_chips/Spreading_rate);
Filter_delay_chips_correction=(Spreading_rate-rem(Filter_delay_chips,Spreading_rate));
if (Filter_delay_chips_correction==Spreading_rate)
    Filter_delay_chips_correction=0;  %Ignore if mulitple of spreading rate
end
assignin('base','Filter_delay_chips_correction',Filter_delay_chips_correction);

% Set noise
evalin('base',['EsNo=' num2str(EsNo) ';']);

% Walsh codes for DWT in Receiver
evalin('base','load cck_codes');

% Select channel type
set_param([Modelname '/Channel'],'BlockChoice',Channel_type)

% Select center frequency
Center_frequency =(Channel_number-6) *5;

if Center_frequency~=0
    % Turn on 
    set_param([Modelname '/Transmitter/Upsample and pulse shape/Mix to'],'BlockChoice','Mix to center frequency');
    set_param([Modelname '/Receiver/Rx Front/Mix from'],'BlockChoice','Mix from center frequency');
else
    % Turn off 
    set_param([Modelname '/Transmitter/Upsample and pulse shape/Mix to'],'BlockChoice','No mix to center frequency');
    set_param([Modelname '/Receiver/Rx Front/Mix from'],'BlockChoice','No mix from center frequency');
end  
evalin('base',['Center_frequency=' num2str(Center_frequency) ';']);

% Set PLCP framesizes plus some PSDU, PPDU sizes
if Short_preamble
    evalin('base','Sync_size=56;');
else
    evalin('base','Sync_size=128;');
end

evalin('base','Sync_bits=randint(Sync_size,1,2,12345);');

evalin('base',['Short_preamble=' num2str(Short_preamble) ';']); % Delay is function of preamble

evalin('base','SFD_size=16;');
evalin('base','Signal_size=8;');
evalin('base','Service_size=8;');
evalin('base','Length_size=16;');
evalin('base','CRC_size=16;');
evalin('base','PLCP_preamble_size=Sync_size+SFD_size;');
evalin('base','PLCP_header_size=Signal_size+Service_size+Length_size+CRC_size;');
evalin('base','PLCP_size=PLCP_preamble_size+PLCP_header_size;');
evalin('base', ['Packet_size=' num2str(Packet_size) ';']);
evalin('base', 'PSDU_size=Packet_size*8;');
evalin('base', 'PPDU_size=PSDU_size+PLCP_size;');

if Short_preamble
    evalin('base', 'PLCP_size_symbols=PLCP_preamble_size+PLCP_header_size/2;'); % Combination DBPSK, DQPSK
else
    evalin('base', 'PLCP_size_symbols=PLCP_size;'); % Due to DBPSK 
end

% Channel size change configure
Channel_size_change=0;

evalin('base', ['Channel_size_change=' num2str(Channel_size_change) ';']);

% Mod and demod configure
switch Mode
case 1
    
    set_param([Modelname '/Transmitter/Modulate and spread'],'BlockChoice','1Mbps mod');
    set_param([Modelname '/Receiver/Demodulate and despread'],'BlockChoice','1Mbps demod');
    
    evalin('base', 'PSDU_size_symbols=PSDU_size;');
    evalin('base', 'PPDU_size_symbols=PSDU_size_symbols+PLCP_size_symbols;');
    evalin('base', 'PPDU_size_chips=PPDU_size_symbols*Spreading_rate;');
   
    evalin('base', 'Num_frames_delay=(2+Channel_size_change);');
    evalin('base', 'PLCP_preamble_receive_delay=PLCP_preamble_size*Num_frames_delay;'); 
    evalin('base', 'PSDU_receive_delay=PSDU_size*Num_frames_delay;'); 
    evalin('base', 'PLCP_header_receive_delay=PLCP_header_size*Num_frames_delay;'); % One frame delay due to upsampling, one due to aligmment

    evalin('base', 'PLCP_preamble_computation_delay=1;');     % Due to DBPSK     
    evalin('base', 'PLCP_header_computation_delay=2*Short_preamble;');     
    evalin('base', 'PSDU_computation_delay=0;');  
    
    evalin('base', 'PPDU_frame_period=PPDU_size_symbols*1e-6;');
    
case 2
    
    set_param([Modelname '/Transmitter/Modulate and spread'],'BlockChoice','2Mbps mod');
    set_param([Modelname '/Receiver/Demodulate and despread'],'BlockChoice','2Mbps demod');
    
    evalin('base', 'PSDU_size_symbols=PSDU_size/2;');    
    evalin('base', 'PPDU_size_symbols=PSDU_size_symbols+PLCP_size_symbols;');
    evalin('base', 'PPDU_size_chips=PPDU_size_symbols*Spreading_rate;');

    evalin('base', 'Num_frames_delay=(2+Channel_size_change);');
    evalin('base', 'PLCP_preamble_receive_delay=PLCP_preamble_size*Num_frames_delay;'); % One frame delay
    evalin('base', 'PSDU_receive_delay=PSDU_size*Num_frames_delay;'); % One frame delay
    evalin('base', 'PLCP_header_receive_delay=PLCP_header_size*Num_frames_delay;'); % One frame delay
  
    evalin('base', 'PLCP_preamble_computation_delay=1;');     % Due to DBPSK     
    evalin('base', 'PLCP_header_computation_delay=2*Short_preamble;');     % Due to DBPSK  
    evalin('base', 'PSDU_computation_delay=2;');     % Due to DQPSK 
    
    evalin('base', 'PPDU_frame_period=PPDU_size_symbols*1e-6;');

 case 3
    
    set_param([Modelname '/Transmitter/Modulate and spread'],'BlockChoice','5.5Mbps mod');
    set_param([Modelname '/Receiver/Demodulate and despread'],'BlockChoice','5.5Mbps demod');
    
    evalin('base', 'PPDU_size_chips=PSDU_size*2+PLCP_size_symbols*Spreading_rate;');
    evalin('base', 'PPDU_frame_period=PPDU_size_chips/Chip_rate;');
    evalin('base', 'PSDU_size_symbols=0;'); 
    evalin('base', 'PPDU_size_symbols=0;'); 
          
    evalin('base', 'Num_frames_delay=(2+Channel_size_change);');
    evalin('base', 'PLCP_preamble_receive_delay=PLCP_preamble_size*Num_frames_delay;'); % One frame delay
    evalin('base', 'PSDU_receive_delay=PSDU_size*Num_frames_delay;'); % One frame delay
    evalin('base', 'PLCP_header_receive_delay=PLCP_header_size*Num_frames_delay;'); % One frame delay
    
    evalin('base', 'PLCP_preamble_computation_delay=1;');     % Due to DBPSK     
    evalin('base', 'PLCP_header_computation_delay=2*Short_preamble;');   
    evalin('base', 'PSDU_computation_delay=2;'); % Due to first DQPSK of CCK

    evalin('base', 'PPDU_frame_period=PPDU_size_chips/Chip_rate;');

case 4
    
    set_param([Modelname '/Transmitter/Modulate and spread'],'BlockChoice','11Mbps mod');
    set_param([Modelname '/Receiver/Demodulate and despread'],'BlockChoice','11Mbps demod');
    
    evalin('base', 'PPDU_size_chips=PSDU_size+PLCP_size_symbols*Spreading_rate;');
    evalin('base', 'PSDU_size_symbols=0;'); 
    evalin('base', 'PPDU_size_symbols=0;'); 
    
    evalin('base', 'Num_frames_delay=(2+Channel_size_change);');
    evalin('base', 'PLCP_preamble_receive_delay=PLCP_preamble_size*Num_frames_delay;'); % One frame delay
    evalin('base', 'PSDU_receive_delay=PSDU_size*Num_frames_delay;'); % One frame delay
    evalin('base', 'PLCP_header_receive_delay=PLCP_header_size*Num_frames_delay;'); % One frame delay

    evalin('base', 'PLCP_preamble_computation_delay=1;');       % Due to DBPSK     
    evalin('base', 'PLCP_header_computation_delay=2*Short_preamble;');     % Due to DBPSK 
    evalin('base', 'PSDU_computation_delay=2;'); % Due to first DQPSK of CCK

    evalin('base', 'PPDU_frame_period=PPDU_size_chips/Chip_rate;');
end


% Select  preamble size

if Mode~=1 % Set preamble correctly for 2, 5.5 and 11Mpbs modes
    
	Mod_block_choice=get_param([Modelname '/Transmitter/Modulate and spread'], 'BlockChoice');
	Demod_block_choice=get_param([Modelname '/Receiver/Demodulate and despread'], 'BlockChoice');
	
	if Short_preamble
	    set_param([Modelname '/Transmitter/Modulate and spread/' Mod_block_choice],'Short_preamble','on');
	    set_param([Modelname '/Receiver/Demodulate and despread/' Demod_block_choice],'Short_preamble','on');
	else
	    set_param([Modelname '/Transmitter/Modulate and spread/' Mod_block_choice],'Short_preamble','off');
	    set_param([Modelname '/Receiver/Demodulate and despread/' Demod_block_choice],'Short_preamble','off');
	end
end


% Calculate delay as a result of buffering the channel - buffer_frame_delay
% Calcuate delay required to move to frame boundary - frame_move_delay

PPDU_size_chips=evalin('base', 'PPDU_size_chips');
Channel_size=evalin('base', 'Channel_size');

if PPDU_size_chips>Channel_size
    if rem(PPDU_size_chips,Channel_size)==0  % Channel_size multiple of PPDU_chip_size
        evalin('base', 'Buffering_delay=PPDU_size_chips;');
    else 
        evalin('base', 'Buffering_delay=2*PPDU_size_chips+Channel_size;');
    end
    
else 
    if rem(Channel_size,PPDU_size_chips)==0  % PPDU_chip_size multiple of Channel_size
        evalin('base', 'Buffering_delay=Channel_size;');
    else 
        evalin('base', 'Buffering_delay=PPDU_size_chips + 2*Channel_size;'); 
    end
end

evalin('base', 'Correction_delay=8*PPDU_size_chips-Buffering_delay;'); 

% Handle large delays
if Channel_size_change
    Correction_delay=evalin('base', 'Correction_delay'); 
    if Correction_delay < 0
        error('Currently this model cannot handle this combination of packet size and channel size. Consider making their values closer or don''t resize channel') 
    end
end 