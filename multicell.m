% clc;
% clear;
%col={'blue' 'red' 'green' 'cyan' 'magenta' 'black'};figure ;hold

% clear all
% clc

% s=rng
% load see.mat
% rng(seed)
interference12=zeros(1,4);
e=[8/9 10/9 7/9 11/9 8/9 7/9];
d=([3/2 4/2 5/2 3/2 5/2 4/2]).^(-4);
 n= (8.*randn(7,1))/10;
 n0=n(7);
 r=(10.^(n))/(10^(n0));
 
 interference11=zeros(1,6);interference=0;
 
    
    interference11(1)=e(1)*d(1)*r(1);
        
    
for m=2:6
                
    interference=e(m)*d(m)*r(m);
    interference11(m)=interference11(m-1)+interference;
end

interference12(1)=interference11(1);
interference12(2)=interference11(2);
interference12(3)=interference11(4);
interference12(4)=interference11(6);
%  save default s

load see.mat
rng(seed);
hConvEnc = comm.ConvolutionalEncoder(poly2trellis(7, [171 133]));
hConvEnc.TerminationMethod = 'Truncated';

hModulator = comm.QPSKModulator('PhaseOffset',pi/4);
hDemod = comm.QPSKDemodulator('PhaseOffset',pi/4);

hVitDec = comm.ViterbiDecoder(poly2trellis(7, [171 133]), ...
  'InputFormat', 'Hard');
hVitDec.TerminationMethod = 'Truncated';
hVitDec.TracebackDepth = 24;
hError = comm.ErrorRate;

totCarriers=512;
cariersPerUser=48;
a=[ones(48,1) ;zeros(288-48,1)];
w=512-64+1;
SNR1 = 0:1:10;
Ber=zeros(size(SNR1));
inter123=zeros(1,4);
inter123=interference12;
for h=1:4
for idx = 1:length(SNR1) 
    errorstatus=zeros(100,1);
    for itr=1:100
        c = [];
        for i=0:5
            c =[c circshift(a, [48*i, 0])];
        end

   % QPSK Modulation
 
      % Create a QPSK modulator System object with bits as inputs and Gray-coded signal constellation
      % Change the phase offset to pi/16
      % hModulator.PhaseOffset = pi/16;
      % Convolutionally encode the data
      modData=zeros(48,6);x=zeros(24,6);
      
        for i=1:6
            % Create binary data for 24, 2-bit symbols
            x(:,i) = randi([0 1],24,1); 
            % Convolutionally encoding data
            encData = step(hConvEnc, x(:,i));
            %Interleaving coded data
            inter = randintrlv(encData,48);
            % Modulate and plot the data
            modData(:,i) = step(hModulator, inter);
        end
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
   
     ynoisy = awgn(y,SNR1(idx),'measured');
%    Addition of Rayleigh Fading 
%    rayc = rayleighchan(1/1000,100,[0 2e-5],[0 -9]);
%    rf = filter(rayc,ynoisy);
         rf(:,h)=ynoisy+inter123(h);
 %RECEIVER
      recOFDMsym=  repmat(rf(:,h),1,6);
      CPremoved = recOFDMsym(65:end,:);
      tDomainData=fft(CPremoved,512);
      realignedData= tDomainData(1:(48*6),:);
      deresizedData=realignedData.*c;
      ck = [];
      decData=zeros(24,6);
for i=0:5
ck =[ circshift(deresizedData(:,i+1), [-48*i, 0])];
datatoDemod=ck(1:48,:);
      modData = step(hDemod, datatoDemod(:));
      recdata=reshape(modData,48,[]);
      %de interleave data
    deinter = randdeintrlv(recdata,48); 
    % input to the Viterbi decoder.
    decData(:,i+1) = step(hVitDec, real(deinter));
    ck=[];
end
      
    % Calculate the errors
      errorrate = step(hError, x(:), decData(:)); 
       reset(hError);
       errorstatus(itr)=errorrate(1);
    end
    Ber1(h,idx)=mean(errorstatus);
    
end


end
% save bernp1 Ber1
% save snr1 SNR1

      figure
semilogy(SNR1,Ber1(1,:),SNR1,Ber1(2,:),SNR1,Ber1(3,:),SNR1,Ber1(4,:))
xlabel('Eb/No (dB)'); ylabel('BER');
legend('no puncturing')
title('BER for coded OFDMA System without puncturing'); 
grid on