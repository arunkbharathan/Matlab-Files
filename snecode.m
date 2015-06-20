clear all
clc
No_sc=16;
cp=3;
No_tap=3;
No_blocks=3;
No_bits=48;
No_itr=10000;
Max_SNR=40;
Rs=.5^.5;
for SNR=0:5:Max_SNR
SNRab=10^(SNR/10);
sd=sqrt((1/(2*SNRab)));
error=0;
for itr=1:No_itr
data = randint(1,No_bits);
b_data= pskmod(data,4);
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
rt(qw)= rt(qw)+ (hh(wq)*(exp(-(2*i*pi*(qw-1)*(wq-1))/No_sc))) ;
end
end
for z=1:No_sc
Rx(No_sc*(t-1)+z)= RR(z)/rt(z);
end
end
data_rx = pskdemod(Rx,4);
error=error+sum(xor(data_rx,data));
end
BER((SNR/5)+1)=error/(No_itr*48);
end
x=0:5:Max_SNR;
semilogy(x,BER,'color',[1 0 0],'linewidth',2.5);
grid on
axis([0 Max_SNR .00001 1]);
xlabel('SNR(dB)');
ylabel('BER');