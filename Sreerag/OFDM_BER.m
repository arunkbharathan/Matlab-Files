clear all
 close all
 clc
 
 

nbitpersym  = 45;   % number of bits per qam OFDM symbol (same as the number of subcarriers for 16-qam)
len_fft     = 64;   % fft size
sub_car     = 45;   % number of data subcarriers
EbNo        = -15:1:20;
EsNo= EbNo+10*log10(45/64)+ 10*log10(64/80) +10*log10(2);
snr=EsNo - 10*log10((64/80));
for i=1:length(EbNo)
SNRvalue=snr(i);
sim('ofdmBAsic', 99.99);
ber(i)=ErrorVec(1);
end
semilogy(EbNo,ber,'r');grid;%axis([-15 20 0 0.5])

