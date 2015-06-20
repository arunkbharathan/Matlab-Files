%hw1 for EE650 Fall 2006      ###10/12/2006
%Zhijin Wang 809735310 zwang@rohan.sdsu.edu

%problem 5
% 5. Implement a coherently detected BPSK system on MATLAB and obtain its PB vs E/N0
% characteristic experimentally. Compare it with a graph of the Q(sqrt(2E/N0)) function.
% • Do not simulate RF signals. Use complex envelopes instead.
% • Use a sampling rate of 4 samples every symbol.
% • Simulate the system for 10000 bits and obtain PB as the ratio of the number of
% errors to the total number of bits transmitted (equal to 10000 here).
% • Simulate for values of E/N0
% equal to 1, 2, . . . , 10 in decibels. Then plot the graph
% in MATLAB. You can change the E/N0
% value by changing the value of E in the
% q2E
% T (equivalent to the q2E
% N in a digital implementation, with N = 4 here) term.
% Retain the value of N0 as 1. Simulate for E values of 1, 2, . . . , 10 dB to get different
% E
% N0
% values.
% • Generate the digital AWGN signal n[k] (sampled n(t)) by generating zero mean
% Gaussian random variables independently (separately) for each k using the
% MATLAB function random. The Gaussian random variables should have a variance
% N0 (not N0
% 2 , see note below).
% NOTE: Band pass signals have only half the energy of their complex envelopes.
% It can be verified that if s(t) = g(t) cos(!0t), then s(t) has only half
% the energy of g(t). Here, even though q2E
% T cos(!0t) has energy equal to one,
% its complex envelope q2E
% T has energy equal to two. So, noise should also
% have twice the power and is hence N0 instead of N0
% 2 .
% 1

%BPSK
%Draw Pe/(Eb/N0) and Q(sqrt(2*E/N0))
clear all;

Eb_N0=[1,2,3,4,5,6,7];%,8]%,9,10];%, 13, 15, 17 19, 20,30]; %in dB. 0-100  enough for plots? 
N0=1; %noise power, Eb=Eb_N0, since N0=1;
Eb=Eb_N0*N0;
N=4;%sample rate: 4smaples/symbol
%number of messages 10000
symbol_number=10000;%increase to 100000 for better results

%@@@@@@@@@@@@@step 1: generate messages;@@@@@@@@@@@@@@
m=rand(1,symbol_number);%m[k] 10000 symbols
[i]=find(m>0.5);
[j]=find(m<=0.5);
%generate 0 1 messages
m(i)=1;% all random 1s
m(j)=0;% all random 0s

for k=1:length(Eb) %10 SNR Eb/N0
    
    %@@@@@@@@@@@@@step 2: implement BPSK @@@@@@@@@@@@@@@@
    %Energy:sqrt(2*Eb/N), N=4;
    E=10^(Eb(k)/10);%get values, not in dB.
    E=sqrt(2*E/N);
    %generate 40000=N*symbol_number;
    %message=ones(1,N*symbol_number);%40000 passband messages
    %message=message*E; %modulate amplitude: sqrt(2*Eb/N)
    %s1 & s2
    s1=ones(1,N)*E;
    s2=ones(1,N)*(-E);
    
    for i=1:symbol_number
        if m(i) ==0
            message((i-1)*(N)+1:(i-1)*(N)+N)=s2;% BPSK +1/-1
        else
            message((i-1)*(N)+1:(i-1)*(N)+N)=s1;% BPSK +1/-1
        end
    end
    
    %@@@@@@@@@@@@STEP 3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %AWGN NOISE CHANNEL
    AWGN_NOISE=random('Normal',0,1,1,symbol_number*N);
    
    %@@@@@@@@@@@@STEP 4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %ADD NOISE TO SIGNALS
    %received signals
    % y=awgn(x,10)
    received_signal=awgn(message,Eb(k));
    %received_signal=message+AWGN_NOISE; %not good. not AWGN?
    
    %@@@@@@@@@@@STEP 5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %SINCE IT IS BPSK, SAMPLED MATCHED FILTERS
    for j=1:N
        c1(j)=s1(5-j);
        c2(j)=s2(5-j);
    end
    
    %@@@@@@@@@@@@@@@STEP 6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %Matched filters, get VALUES OF CONV.
    Z1=conv(received_signal,c1);%length is 40003
    Z2=conv(received_signal,c2);%length is 40003
    
    %@@@@@@@@@@@@@@Step 7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %downsampling by 4 and demodulation/decoding
    for i=1:symbol_number
        m_hat(i)=Z1(i*N-1)>Z2(i*N-1);%if >, then 1; if <, then 0
    end
    
    %@@@@@@@@@@@@@@@@STEP 8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %Compare m_hat[k] and m[k] and count errors
    %XOR
    error=xor(m_hat,m);
    %get number of errors 
    error_number=length(find(error>0))
    %prob. of error
    Pb(k)=error_number/symbol_number;%kth error prob. for diff SNR: Eb/N0
    
end%k

figure
semilogy(Eb_N0,Pb);
Title('Error Prob. of BPSK');
xlabel('Eb/N0(dB)');
ylabel('Pb(Log Scale)');
legend ('Prob. of Error')
%Q function
Qx=(1/2)*erfc((10.^(Eb/10))/sqrt(2));
%plot figures
figure
semilogy(Eb_N0,Pb,'r+-',Eb_N0,Qx);
Title('Error Prob. of BPSK with Comparision of Q(SQRT(2Eb/N0))');
xlabel('Eb/N0(dB)');
ylabel('Pb(Log Scale)');
legend ('Prob. of Error','Q(SQRT(2Eb/N0))')
figure
plot(Eb_N0,Pb,'r',Eb_N0,Qx);
Title('Error Prob. of BPSK');
xlabel('Eb/N0(dB)');
ylabel('Pb');
legend ('Prob. of Error','Q(x)')


%q function: Q(sqrt(2*E/N0)), Q(x): y=(1/2)*erfc(x/sqrt(2))