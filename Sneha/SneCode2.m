clc;
clear;
%col={'blue' 'red' 'green' 'cyan' 'magenta' 'black'};figure ;hold
x = randi([0 1],24*6,1); 
hConvEnc = comm.ConvolutionalEncoder(poly2trellis(7, [171 133]));

hModulator = comm.QPSKModulator('PhaseOffset',pi/4);
hDemod = comm.QPSKDemodulator('PhaseOffset',pi/4);

hVitDec = comm.ViterbiDecoder(poly2trellis(7, [171 133]), ...
  'InputFormat', 'Unquantized');
hVitDec.TracebackDepth = 40;
hError = comm.ErrorRate;

totCarriers=512;
cariersPerUser=48;
a=[ones(48,1) ;zeros(288-48,1)];
w=512-64+1;
c = [];
for i=0:5
c =[c circshift(a, [48*i, 0])];
end

 % Create binary data for 48, 2-bit symbols
       
 
 % QPSK Modulation
 
       % Create a QPSK modulator System object with bits as inputs and Gray-coded signal constellation
     
       % Change the phase offset to pi/16
      % hModulator.PhaseOffset = pi/16;
      % Convolutionally encode the data
        encData = step(hConvEnc, x);
        inter = randintrlv(encData,48);
       % Modulate and plot the data
       modData = step(hModulator, inter);
       
       stackData=reshape(modData,48,6);
       resizing1=repmat(stackData,6,1);
       alignedData=resizing1.*c;
       fDomainData=ifft(alignedData,512);
        CP=fDomainData(449:end,:);
        CPadded=[CP;fDomainData];
        %END OF TRANSMITTER
        
        %CHANNEL
        y=sum(CPadded,2);
        % Signal transmits through AWGN channel.
    ynoisy = awgn(y,100,'measured');
% Addition of Rayleigh Fading 
    rayc = rayleighchan(1/1000,100,[0 2e-5],[0 -9]);
    rf = filter(rayc,ynoisy);
        
        %START OF RECEIVER
      recOFDMsym=  repmat(rf,1,6);
      CPremoved = recOFDMsym(65:end,:);
      tDomainData=fft(CPremoved,512);
       realignedData= tDomainData(1:(48*6),:);
      deresizedData=realignedData.*c;
      c = [];
for i=0:5
c =[c circshift(deresizedData(:,i+1), [-48*i, 0])];
end
datatoDemod=c(1:48,:);
      modData = step(hDemod, datatoDemod(:));
      recdata=reshape(modData,48,[]);
      %de interleave data
    deinter = randdeintrlv(recdata,48); 
    % input to the Viterbi decoder.
    decData = step(hVitDec, real(deinter));
      
EbNo = 0:2:16;
for idx = 1:length(EbNo)
    % Calculate the errors
      errorstatus(:,idx) = step(hError, x, decData(:)); 
      semilogy(EbNo(1:idx), errorstatus(1,1:idx), 'ro');
end
xlabel('Eb/No (dB)'); ylabel('BER');
title('OFDMA System'); 
grid on

      