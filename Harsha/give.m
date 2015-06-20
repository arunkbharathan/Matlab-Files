clear all;
hChan = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (Eb/No)',...
  'SignalPower', 1, 'SamplesPerSymbol', 1);
users=2;
n=4;
walsh=hadamard(n);
code1=walsh(2,:);
code2=walsh(4,:);

N=8^4;
M=8^4;
user1=rand(1,N)>0.5;
user1_bpsk=2*user1-1;

tran1=user1_bpsk';
spdata1=user1_bpsk'*code1;
for tt=1:size(spdata1,2)
wave_data1(:,tt)=islantlt(spdata1(:,tt));
end
for tt=1:size(spdata1,2)
wave_data2(:,tt)=slantlt(wave_data1(:,tt));
end

wave_data1=wave_data1';
padd=zeros(4096,4);
pad_data1=[padd(:,[(n-2):n]) wave_data1];
transdata1=pad_data1';

% user2=rand(1,M)>0.5;
% user2_bpsk=2*user2-1;
% spdata2=user2_bpsk'*code2;
% wave_data2=islantlt(spdata2');
% wave_data2=wave_data2';
% pad_data2=[padd(:,[(n-2):n]) wave_data2];
transdata2=pad_data2';
x=transdata1+transdata2;

snr=[1:20];
len=length(snr);
for i=1:length(snr)

     channelOutput = awgn(x,snr(i),'measured');
% channelOutput = step(hChan,x);
 rcvdata=channelOutput';
 ky=length(rcvdata);
 
 
 %removal of zero padding
 
%rem_data=reshape(rcvdata,(n+3),length(rcvdata)/(n+3));
rem_data = rcvdata(:,[(4:(n+3))]); 
transform_out=slantlt(rem_data');
recdata11=real(transform_out'*code1')';
for j=1:4096
if recdata11(j)<0
    recdata11(j)=0;
else recdata11(j)=1;
end
recdata12=real(transform_out'*code2')';

    errors_user1(i) = size(find([user1-recdata12]),2)
    ber=errors_user1/N;
    recdata22=real(transform_out'*code2')';
for kj=1:4096
if recdata22(k)<0
    recdata22(k)=0;
else recdata22(k)=1;
end
end

errors_user2(i) = size(find([user2-recdata22]),2); %Errors for User1
ber2=errors_user2(i)/M;
end
end

figure;

semilogy(snr,SBer1,'bd','LineWidth',4);
hold on;
semilogy(snr,SBer2,'go-','LineWidth',1);
axis([0 50 10^-5 0.5]);
grid on
legend('Simulated BER for User1','Simulated BER for User2');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');