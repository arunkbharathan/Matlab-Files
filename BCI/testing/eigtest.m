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
eigshow(P2+P1)
y=(a*p1')';
plot(y(:,1),y(:,2),'.k')

y1=(sqrt(inv(b))*y')';
plot(y1(:,1),y1(:,2),'.m')

[a b]=eig(P2);
y=(a*p2')';
plot(y(:,1),y(:,2),'.g')
y1=(sqrt(inv(b))*y')';
plot(y1(:,1),y1(:,2),'.y')

figure;plot(p1(:,1),p1(:,2),'.');hold on;grid;plot(p2(:,1),p2(:,2),'.r')
[vec val]=eig(P1+P2);
[val,ind] = sort(diag(val),'descend');
vec = vec(:,ind);val=diag(val);
p=pinv(sqrt(val))*vec';
SCf=p*P1*p';
SCh=p*P2*p';
% y=(SCf*p1')';
% plot(y(:,1),y(:,2),'.g')
% y=(SCh*p2')';
% plot(y(:,1),y(:,2),'.k')
eigshow(p)


[U1 sigmaF]=eig(SCf);
[sigmaF,ind] = sort(diag(sigmaF),'descend');
U1 = U1(:,ind);sigmaF=diag(sigmaF);

[U2 sigmaH]=eig(SCh);
[sigmaH,ind] = sort(diag(sigmaH),'ascend');
U2 = U2(:,ind);sigmaH=diag(sigmaH);
U=U2;
W=(U'*p)';imagesc(inv(W))
y=(W*p1')';
plot(y(:,1),y(:,2),'.m')
y=(W*p2')';
plot(y(:,1),y(:,2),'.k')

i=1;
Uf=U(:,1:i);
Uh=U(:,end-i+1:end);
Ur=U(:,2+i:end-1-i);
SFf=Uf'*p;
SFh=Uh'*p;
% SFr=Ur'*P;
figure;grid
y=(SFf*p1')';var(y)
plot(y,'.m');hold
y=(SFh*p1')';var(y)
plot(y,'.')

y=(SFf*p2')';var(y)
plot(y,'.g')
y=(SFh*p2')';var(y)
plot(y,'.k')


% [U1 sigmaF]=eig(SCf);
% [U2 sigmaH]=eig(SCh+SCf);
% U=U2;
% W=p'*U;
% y=(W*p1')';
% plot(y(:,1),y(:,2),'.m')
% y=(W*p2')';
% plot(y(:,1),y(:,2),'.y')
% 
% i=1;
% Uf=U(:,1:i);
% Uh=U(:,end-i+1:end);
% Ur=U(:,2+i:end-1-i);
% SFf=Uf'*p;
% SFh=Uh'*p;
% % SFr=Ur'*P;
% figure;grid
% y=(SFf*p1')';var(y)
% 
% y=(SFh*p1')';var(y)
% 
% 
% y=(SFf*p2')';var(y)
% 
% y=(SFh*p2')';var(y)
% 
% 
% [U1 sigmaF]=eig(SCf);
% [U2 sigmaH]=eig(SCh,SCh+SCf);
% U=U2;
% W=p'*U;
% y=(W*p1')';
% plot(y(:,1),y(:,2),'.m')
% y=(W*p2')';
% plot(y(:,1),y(:,2),'.y')
% 
% i=1;
% Uf=U(:,1:i);
% Uh=U(:,end-i+1:end);
% Ur=U(:,2+i:end-1-i);
% SFf=Uf'*p;
% SFh=Uh'*p;
% % SFr=Ur'*P;
% figure;grid
% y=(SFf*p1')';var(y)
% 
% y=(SFh*p1')';var(y)
% 
% 
% y=(SFf*p2')';var(y)
% 
% y=(SFh*p2')';var(y)
