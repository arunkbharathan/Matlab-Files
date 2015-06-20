clear all;clc; bpsk = comm.BPSKModulator;
 %**************************************Input parameters********************************************************************************** 
 b = [ 1 0 0 1 1]; % Input bit stream 
 N=[16 32 64]; 
for j=1:length(N)
    snr_db=0:1:20;
g=length(snr_db);


%*************************************BPSK signal generation, Matched filtering and Sampling********************************************
for z=1:length(snr_db)
%[signal]=bpsk(b); 
signal = real(step(bpsk, b'))';
signal=repmat(signal,[7 1]);signal=signal(:);
%BPSK signal generation
signal_fad=signal;%b_fad(signal); %fading 
[s_matched]=matche(signal_fad,snr_db(z)); % matched filtered output of Qpsk signal
%************************************Entropy anlaysis after matched filter output is sampled******************************************** 
 L=N(j); %No.of bins
 s=s_matched(1:N(j)); % N no.of samples Sampled output of matched filter 
 x=[ ];
x=s(1:N(j)); %block of N samples of matched filter to make decision
 %noise=noise(1:N(j));
 K=4;
 sq=sum(x.^2)/N(j);
sigma = sqrt(sum(x.^2)/N(j));
 %**********************************checking for chebyeshev inequality*******************************************************************
 count=0;
 for i=1:N(j)
 if(abs((x(i)-mean(x)))>(K*sigma)) 
 count=count+1;
 else
     count=count;
end
end
if ((count/N(j))<= (1/(K^2)))
 %display('Design value of K is correct ');
 else
%display('Design value of K is incorrect and try for another value');
 end
% %***********************************Histogram of x**************************************************************************************
v1=(2*K*sigma)/(L); % Width of each bin
v=-K*sigma:v1 :K*sigma; % a vector specifying the centres of bins from where to start and stop.
 %***********************************Checking for no.of values of x fallong inside the kth bin********************************************
 pa11=0;
 pa01=0; y1=0;e(z)=0;
 for k=1:L;
 number_samples=0;
 lk(k)=v(k)-(v1/2);
 lkplus1(k)=v(k)+(v1/2);
for i=1:N(j)
 if((lk(k)<x(i))& (x(i)<lkplus1(k)))
 number_samples=number_samples+1;
 else
 number_samples=number_samples+eps;
 end
 end 
nk=number_samples; 
y1=y1+number_samples;
 %----------------------------------------Entropy caculation------------
 if(nk~=0)
    nk=nk;
 else
nk=nk+eps; 
end
p(k) = -((nk/N(j))*log2(nk/N(j)));
 e(z)= e(z)+p(k) ; %Entropy estimate
 %********************************************computing pk(a)********************************************************************************
 a1=snr_db(z);
 a0=0; 
 pk1=0;pk0=0; M=2; u(1)=1;u(2)=-1;
for m=1:M
 h1(m)=0;h2(m)=0;h3(m)=0;h4(m)=0; 
 h1(m)=(lk(k)-u(m)*sqrt(a1/(1+a1)))*(1+a1);
 h2(m)=(lkplus1(k)-u(m)*sqrt(a1/(1+a1)))*(1+a1);
 h3(m)=(lk(k)-u(m)*sqrt(a0/(1+a0)))*(1+a0);
 h4(m)= (lkplus1(k)-u(m)*sqrt(a0/(1+a0)))*(1+a0);
 pk1=pk1+[[qfunc(h1(m))]-[qfunc(h2(m))]];
 pk0=pk0+[[qfunc(h3(m))]-[qfunc(h4(m))]];
end
 pka1= (1/M)*pk1+eps;
pka0= (1/M)*pk0+eps;
 %*********************************************computing log-likelihood ratio***************************************************************
pa11=pa11+(nk/N(j))*[log2(pka1)-log2(pka0)];
 end
 le(z)=pa11;%Log-likelihood ratio of entropy
 end 
 e1((j+(j-1)*20):j*21)=e;
le1((j+(j-1)*20):j*21)=le;
 end
 plot(snr_db,e1(1:21),'-b*',snr_db,e1(22:42),'-ro',snr_db,e1(43:63),'-g.');
 xlabel('SNR in db');
 ylabel('Entropy');
 title('Normal entropy');
h2=legend('N=16 BPSK','N=32 BPSK','N=64 BPSK',1); 
 figure
 plot(snr_db,le1(1:21),'-b*',snr_db,le1(22:42),'-ro',snr_db,le1(43:63),'-g.');
xlabel('SNR in db');
 ylabel('Log-likelihood Entropy');
 title('log-likelihood entropy')
 h2=legend('N=16 BPSK','N=32 BPSK','N=64 BPSK',1);
