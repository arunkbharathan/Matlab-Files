clc;clear;close all
m1=[2 1];m=[0 0];m2=[10 10];
p1=mvnrnd(m1,[5 10;10 25],500);
p2=mvnrnd(m2,[7 5;5 49],500);
plot(p1(:,1),p1(:,2),'.')
hold on;grid
plot(p2(:,1),p2(:,2),'.r')

P1=cov(p1);
P2=cov(p2);
[a b]=eig(P1);
arrow(m1,3*[a(:,1)']+m1);
arrow(m1,5*[a(:,2)']+m1);
[a b]=eig(P2);
arrow(m2,3*[a(:,1)']+m2);
arrow(m2,5*[a(:,2)']+m2);
%CSP Steps

[vec val]=eig(P1+P2);
arrow(m,5*[vec(:,1)']+m);
arrow(m,5*[vec(:,2)']+m);
p=pinv(sqrt(val))*vec';
SCf=p*P1*p';
SCh=p*P2*p';
[U1 sigmaF]=eig(SCf);
[U2 sigmaH]=eig(SCh);
U=U1;
sigmaF+sigmaH
W=p'*U;
[U Sigma]=eig(SCf,SCh);
[Sigma,ind] = sort(diag(Sigma),'descend');
U=U(:,ind);
Uf=U(:,1:1);
Uh=U(:,end:end);
Ur=U(:,2:end-1);

SFf=Uf'*p;
SFh=Uh'*p;
SFr=Ur'*P;




