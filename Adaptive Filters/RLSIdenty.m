hn=[1 -1 .5 -.5 .2 .1 .1 ];figure
rng('default');
x=randn(1,1000)';
d=filter(hn,1,x);
%note desired signal d and input signal x
% freqz(hn,1,512);
title('response of hn')

N=7;%if more than 7 coefficients extra coefficients will be near to 0.
W=eps*ones(1,N);
P=eye(7)*1000;
lambda= 0.95;
tic
for i=N:length(x)
    u=x(i:-1:i-(N-1));
    y(i)=W*u;
    e(i)=d(i)-y(i);
    k=(lambda+u'*P*u)\P*u;
    W=W+k'*e(i);
    P=(1/lambda)*(P-k*u'*P);
    MSE(i-6)=e(i)^2;
%       stem([hn;W]');legend('hn','W');
end
toc
figure
% freqz(W,1,512);
title('response of hnadapted by lms');figure
cla
 stem([hn;W]');legend('hn','W');figure
 plot(1:994,MSE/994)
 axis([1 20 -1e-3 16e-3])
 title('RLS')
 %RLS almost achieves in  iterations