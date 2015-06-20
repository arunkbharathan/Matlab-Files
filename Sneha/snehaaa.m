clear all
clc
No_sc=16;
cp=3;
No_tap=3;
No_blocks=8;
No_bits=192;
No_itr=1000;
Max_SNR=40;
Rs=.5^.5;
hConvEnc = comm.ConvolutionalEncoder(poly2trellis(7, [171 133]));
hConvEnc.PuncturePatternSource = 'Property';
hConvEnc.PuncturePattern = [1;1;0;1;1;0];
hVitDec = comm.ViterbiDecoder(poly2trellis(7, [171 133]), ...
  'InputFormat', 'Hard');
hVitDec.PuncturePatternSource =  'Property';
hVitDec.PuncturePattern = hConvEnc.PuncturePattern;
hVitDec.TracebackDepth = 96;
hErrorCalc = comm.ErrorRate('ReceiveDelay', hVitDec.TracebackDepth);
for SNR=0:5:Max_SNR
SNRab=10^(SNR/10);
sd=sqrt((1/(2*SNRab)));
error=0;
for itr=1:No_itr
    reset(hErrorCalc);
  reset(hConvEnc);
  reset(hVitDec);
dataU = randi([0 1],1,No_bits);
a=step(hConvEnc,dataU');
dataE=reshape(a,2,[])';
de = bi2de(dataE);
b_data= pskmod(de,4);
for t=1:No_blocks
for f=1:No_sc
bit_block(f)= b_data(No_sc*(t-1)+f);
s= ifft(bit_block);
end
for n=1:(No_sc+cp)
if n<=cp
ss(n)= s(No_sc-cp+n);
else
ss(n)=s(n-cp);
end
end

n=complex(sd*randn(1,No_sc+cp+No_tap-1),sd*randn(1,No_sc+cp+No_tap-1));
alfa=5;
seg=sqrt((1-exp(-1/alfa))/ (1-exp(-3/alfa)));
n3=randn(1,No_tap);
n4=randn(1,No_tap);

for l=1:No_tap
h(l)=(n3(l)*0.5+n4(l)*0.5i)*(seg*exp(-l/(2*alfa)));
end
r= conv(ss,h);
rx=r+n ;

for k=1:No_sc
rr(k)=rx(k+3);
end
RR= fft(rr) ;
rt=zeros(1,No_sc) ;
hh=zeros(1,No_sc) ;
hh(1,1:No_tap)=h ;
for qw=1:No_sc
for wq=1:No_sc
rt(qw)= rt(qw)+ (hh(wq)*(exp(-(2*1i*pi*(qw-1)*(wq-1))/No_sc))) ;
end
end
for z=1:No_sc
Rx(No_sc*(t-1)+z)= RR(z)/rt(z);
end
end
data_rx = pskdemod(Rx,4);
aa=de2bi(data_rx);data_rx=aa';data_rx=data_rx(:);
ncData = step(hVitDec, data_rx);
curError=step(hErrorCalc, dataU', ncData);
error=error+curError(1);
end
BER((SNR/5)+1)=error/No_itr;
end
x=0:5:Max_SNR;
semilogy(x+10*log10(3/4),BER,'color',randi([0 1],1,3),'linewidth',2.5);
grid on
 axis([0 Max_SNR .00001 1]);
xlabel('SNR(dB)');
ylabel('BER');hold on