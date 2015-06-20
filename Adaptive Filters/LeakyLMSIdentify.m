hn=[1 -1 .5 -.5 .2 .1 .1 ];figure
rng('default');
x=randn(1,1000);
d=filter(hn,1,x);
%note desired signal d and input signal x
% freqz(hn,1,512);
title('response of hn')

N=7;%if more than 7 coefficients extra coefficients will be near to 0.
W=zeros(1,N);
mu=1.5;
tic
for i=N:length(x)
    u=x(i:-1:i-(N-1));
    y(i)=W*u';
    e(i)=d(i)-y(i);
    W=(1-mu*0.0005)*W+mu*u/(u*u')*e(i);
%       stem([hn;W]');legend('hn','W')
MSE(i-6)=e(i)^2;
end
toc
figure
% freqz(W,1,512);
title('response of hnadapted by lms');figure
cla
 stem([hn;W]');legend('hn','W');figure
  plot(1:994,MSE/994)
 axis([1 220 -1e-3 20e-3])
  title('Leaky LMS')
 % LLMS is taking  iterations to almost achieve