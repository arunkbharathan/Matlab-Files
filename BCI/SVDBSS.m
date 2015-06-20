% clc;clear;close all
t=1/8000:1/8000:100;
s3=sin(2*pi*150*t);
s2=square(2*pi*200*t);
s1=sawtooth(2*pi*250*t);
Z=[s1 ;s2; s3]';
A=.5+round((eye(3)+.1*randn(3,3))*1000)/1000
Z=Z;%+.02*randn(8000,3);
X=A*Z';
X=X';
plot(Z(60000:60120,:));pause(.2);
plot(X(60000:60120,:))
[U,S,V] = svd(X,0);
W=inv(S)*V';
Y=W*X';
Y=Y';
plot(Y(60000:60120,:))

%whitening transform or  Sphering Transform
X=X';

E=cov(X')
[V D]=eig(E)
Y=V'*X;plot(Y(:,60000:60120)')
W=inv(sqrt(D))*Y;plot(W(:,60000:60120)')
cov(W')

X=X';

tic;[w s]=runica(X');toc
Y=s*X';
Y=Y';
plot(Y(60000:60120,:))

tic;[w s]=fastica(X');toc
Y=s*X';
Y=Y';
plot(Y(60000:60120,:))