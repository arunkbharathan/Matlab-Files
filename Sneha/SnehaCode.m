NS = 512;
a=zeros(512,6);
cp=zeros(6,576);
e=a';y=0;col={'blue' 'red' 'green' 'cyan' 'magenta' 'black'};figure ;hold
x = randi([0 3],48*6,1);  hModulator = comm.QPSKModulator('PhaseOffset',pi/4);
hDemod = comm.QPSKDemodulator('PhaseOffset',pi/4); hError = comm.ErrorRate;
for i=1:6
 % Create binary data for 48, 2-bit symbols
       
 
 % QPSK Modulation
 
       % Create a QPSK modulator System object with bits as inputs and Gray-coded signal constellation
     
       % Change the phase offset to pi/16
      % hModulator.PhaseOffset = pi/16;
       % Modulate and plot the data
       modData = step(hModulator, x);
%        modData=reshape(modData,48,6);
 
 % Mapping
       l=length(modData);
       z=[zeros(1,(i-1)*l) modData' zeros(1,512-l-(i-1)*l)];
       e(i,1:512)=z';

 % OFDM Modulation for each user
    
    %Taking IFFT of each User
    q=e(i,:);
    a=ifft(q,512);
    %Adding Cyclic Prefix
    N=size(a,2);
    w=N-64+1;
    Y=[a(w:N) a];
    cp(i,:)=Y;
    plot(abs(fft(cp(i,65:end),512)),col{i});
end

% Parellel to serial
    cp=cp';
    out= reshape(cp,1,3456);

% Signal transmits through AWGN channel.
    ynoisy = awgn(out,100,'measured');
% Addition of Rayleigh Fading 
    c = rayleighchan(1/1000,100,[0 2e-5],[0 -9]);
    rf = filter(c,ynoisy); rf=rf'

rf=out;
p=reshape(rf,576,6);
pp=p';
re=zeros(6,512);
subset=zeros(6,48);

for i=1:6
 % OFDM Demodulation for each user
    
    %Removing Cyclic prefix
    rq=pp(i,:);
    rq=rq(:,65:576);
    % Taking FFT
    ra=fft(rq,512);
    re(i,1:512)=ra;
    
 %Demapping
    r=1;
    s=48;
    subset(i,1:48)=re(i,r:s);
    
 %QPSK Demodulation
    
    receivedData(i,1:48) = step(hDemod, subset(i,1:48)');
    
  r=r+s;
  s=s+48;   
end
receivedData=receivedData';
beep




