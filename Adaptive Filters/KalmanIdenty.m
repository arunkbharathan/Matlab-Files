hn=[1 -1 .5 -.5 .2 .1 .1 ];figure
rng('default');
x=randn(1,1000)';
d=filter(hn,1,x);
%note desired signal d and input signal x
% freqz(hn,1,512);
title('response of hn')

N=7;%if more than 7 coefficients extra coefficients will be near to 0.
W=ones(1,N)*eps;


P=eye(N)*eps;
tic
for i=N:length(x)-900
    phi=x(i:-1:i-(N-1));
    y(i)=W*phi;
    e(i)=d(i)-y(i);
    k=(0+phi'*P*phi)\(P*phi);%R measurement noise is 0
    W=W+(k*e(i))';
%     stem([hn;W]');legend('hn','W')
    P=P-k*phi'*P+0;%Q process noise is 0
    MSE(i-6)=e(i)^2;
end
toc
figure
% freqz(W,1,512);
title('response of hn adapted by lms');figure
cla
 stem([hn;W]');legend('hn','W');figure
  plot(1:93,MSE(1:93)/94)
 axis([1 20 -1e-3 170e-3])
  title('KALMAN')
 %What LMS does in 93 iterations kalman does it in 7 iterations.