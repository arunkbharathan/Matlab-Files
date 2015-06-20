hn=[1 -1 .5 -.5 .2 .1 .1 ];figure
rng('default');
x=randn(1,1000);
d=filter(hn,1,x);
%note desired signal d and input signal x
% freqz(hn,1,512);
title('response of hn')

N=7;%if more than 7 coefficients extra coefficients will be near to 0.
W=zeros(1,N);
mu=.1;
tic
for i=N:length(x)
    y(i)=W*x(i:-1:i-(N-1))';
    e(i)=d(i)-y(i);
    W=W+mu*(x(i:-1:i-(N-1)))*sign(e(i));
%      stem([hn;W]');legend('hn','W')
MSE(i-6)=e(i)^2;
end
toc
figure
% freqz(W,1,512);
title('response of hn adapted by lms');figure
cla
 stem([hn;W]');legend('hn','W');figure
   plot(1:994,MSE/994)
 axis([1 400 -1e-3 20e-3])
 title('Sign Error LMS')
 %Sign Error LMS almost achieves in  iterations