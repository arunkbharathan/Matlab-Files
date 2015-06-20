
hn=[1 -1 .5 -.5 .2 .1 .1 ];figure
rng('default');
x=randn(1,1000);
d=filter(hn,1,x);
%note desired signal d and input signal x
% freqz(hn,1,512);
title('response of hn')

N=7;%if more than 7 coefficients extra coefficients will be near to 0.
W=zeros(1,N);
mu=.01;
tic
for i=N:length(x)
    y(i)=W*x(i:-1:i-(N-1))';
    e(i)=d(i)-y(i);
    W=W+mu*x(i:-1:i-(N-1))*e(i);
    MSE(i-6)=e(i)^2;
%      stem([hn;W]');legend('hn','W');hold
end
toc
figure
% freqz(W,1,512);
title('response of hnadapted by lms');figure
cla
 stem([hn;W]');legend('hn','W');figure
 plot(1:994,MSE/994)
 axis([1 320 -1e-3 15e-3])
 title('LMS')
 %LMS almost achieves in 57 iterations