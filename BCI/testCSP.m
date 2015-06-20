clc;clear;close all
m1=[1 2];m=[0 0];m2=[-3 -5];
p1=mvnrnd(m1,[2 0;0 .5],1000);
p2=mvnrnd(m2,[1 0;0 1],1000);
scatter(p1(:,1),p1(:,2),10,'.')
hold on;grid
scatter(p2(:,1),p2(:,2),10,'.r')

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




