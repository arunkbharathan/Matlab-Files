function  [AA BB]=FirstBCI(X,Y)
% [W,training]=
% close all;clc;clear;load Competition_train;
Csum1=zeros(64,64);cnt1=0;Csum2=zeros(64,64);cnt2=0;
EPO1=zeros(64,3000,139);EPO2=zeros(64,3000,139);
%COV1=zeros(64,64,139);COV1=zeros(64,64,139);
X=shiftdim(X,1);%(No: electrodes,samples,trials)
for i=1:length(Y)
    if(Y(i)==1)
        temp=X(:,:,i);
        tt=cov(temp');
         Csum1=tt+Csum1;%figure(1);imagesc(tt)
        cnt1=cnt1+1;
        EPO1(:,:,cnt1)=temp;
 %       COV1(:,:,cnt1)=tt;
    else
        temp=X(:,:,i);
         tt=cov(temp');%figure(2);imagesc(tt)
        Csum2=tt+Csum2;
        cnt2=cnt2+1;
        EPO2(:,:,cnt2)=temp;
%        COV2(:,:,cnt2)=tt;
    end
end
Cavg1=Csum1/cnt1;
Cavg2=Csum2/cnt2;
avg1=sum(EPO1,3)/cnt1;
avg2=sum(EPO2,3)/cnt2;
% ind=covchkChannel(avg1,avg2);
% EPO1=EPO1(ind(1:30),:,:);
% EPO2=EPO2(ind(1:30),:,:);
% avg1=avg1(ind(1:30),:,:);
% avg2=avg2(ind(1:30),:,:);

Cf=Cavg1;
Ch=Cavg2;

% Cf=Xf*Xf'/trace(Xf*Xf')
% Ch=Xh*Xh'/trace(Xh*Xh')
Csum=Cf+Ch;
[Uo sigma]=eig(Csum);
[sigma,ind] = sort(diag(sigma),'descend');
Uo = Uo(:,ind);sigma=diag(sigma);

P=pinv(sqrt(sigma))*Uo';
SCf=P*Cf*P';
SCh=P*Ch*P';

[U1 sigmaF]=eig(SCf);
[sigmaF,ind] = sort(diag(sigmaF),'descend');
U1 = U1(:,ind);sigmaF=diag(sigmaF);

[U2 sigmaH]=eig(SCh);
[sigmaH,ind] = sort(diag(sigmaH),'ascend');
U2 = U2(:,ind);sigmaH=diag(sigmaH);
U=U1;
sigmaF+sigmaH;
W=(U'*P)';%coefficient of spatial filter
 A=pinv(W);%imagesc(W);figure
%imagesc(A);
% Zf=W*Xf;
% Zh=W*Xh;
% [U Sigma]=eig(SCf+SCh);
% 
% [Sigma,ind] = sort(diag(Sigma),'descend');
% U=U(:,ind);
for i=3:3
Uf=U(:,1:i);
Uh=U(:,end-i+1:end);
Ur=U(:,2+i:end-1-i);

SFf{i}=Uf'*P;
SFh{i}=Uh'*P;
SFr{i}=Ur'*P;
end
feature=[];
W=P'*[Uf Uh];
Z=W'*avg1;
 Z=var(Z');
 t=sum(Z);
 Z=log(Z/t);
 feature=[feature; Z];
 
 Z=W'*avg2;
 Z=var(Z');
 t=sum(Z);
 Z=log(Z/t);
 feature=[feature; Z];clear X Y
 X=feature(1,:);Y=feature(2,:);
% w = ((mean(X)-mean(Y))/(cov(X)+cov(Y)))';
% b = (mean(X)+mean(Y))*w/2;
C1feature=[];C2feature=[];

for i=1:139   
       C1= W'*EPO1(:,:,i);
   C1=var(C1');
 t=sum(C1);
 C1=log(C1/t);
 C1feature=[C1feature; C1];
end
for i=1:139   
       C2= W'*EPO2(:,:,i);
   C2=var(C2');
 t=sum(C2);
 C2=log(C2/t);
 C2feature=[C2feature; C2];
end
training=[C1feature;C2feature];
Mu1=mean(C1feature)';
Mu2=mean(C2feature)';
S1=cov(C1feature);
S2=cov(C2feature);
Sw=S1+S2;
SB= (Mu1-Mu2)*(Mu1-Mu2)';
invSw=inv(Sw);
invSw_by_SB=invSw*SB;
[V,D]=eig(invSw_by_SB);
FDV=V(:,1); 
a=C1feature*FDV;
b=C2feature*FDV;
AA=a;BB=b;
% md=(median(a)+median(b))/2;
% me=(mean(a)+mean(b))/2;
% d=me;
% plot(a,'.');hold
% plot(b,'.r');hold off
% line([0 140],[d d],'Marker','.','LineStyle','-','color','b')
% sum((a<d))/length(a)*100
% sum((b>d))/length(b)*100
% (sum((b>d))+sum((a<d)))/(length(b)+length(a))*100
end