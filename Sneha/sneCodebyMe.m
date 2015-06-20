clc;clear
%col={'blue' 'red' 'green' 'cyan' 'magenta' 'black'};figure ;hold
x = randi([0 3],64*8,1);  hModulator = comm.QPSKModulator('PhaseOffset',pi/4);
hDemod = comm.QPSKDemodulator('PhaseOffset',pi/4); hError = comm.ErrorRate;
totCarriers=512;
cariersPerUser=64;
a=[ones(64,1) ;zeros(512-64,1)];
w=512-64+1;
c = [];
for i=0:7
c =[c circshift(a, [64*i, 0])];
end

 % Create binary data for 48, 2-bit symbols
       
 
 % QPSK Modulation
 
       % Create a QPSK modulator System object with bits as inputs and Gray-coded signal constellation
     
       % Change the phase offset to pi/16
      % hModulator.PhaseOffset = pi/16;
       % Modulate and plot the data
       modData = step(hModulator, x);
       stackData=reshape(modData,64,8);
       resizing1=repmat(stackData,8,1);
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
      recOFDMsym=  repmat(y,1,8);
      CPremoved = recOFDMsym(65:end,:);
      tDomainData=fft(CPremoved,512);
       realignedData= tDomainData(1:(64*8),:);
      deresizedData=realignedData.*c;
      c = [];
for i=0:7
c =[c circshift(deresizedData(:,i+1), [-64*i, 0])];
end
datatoDemod=c(1:64,:);
      modData = step(hDemod, datatoDemod(:));
      recdata=reshape(modData,64,[]);
      errorStats = step(hError, x, recdata(:))
      
      
      