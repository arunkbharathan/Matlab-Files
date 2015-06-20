clc;clear all;close all
Fs=1000;c=zeros(18,511);
st=4;
ed=40;
stp=(st:2:ed)/Fs;
for i=1:(length(stp)-1)
c(i,:) = fir1(510,[stp(i) stp(i+1)]);
end
i=88;
k=combntns(1:18,2);opo=[];

qqq=c(k(i,1),:)+c(k(i,2),:);
load('Competition_train.mat')
X=permute(X,[3 2 1]);
parfor j=1:278
temp(:,:,j)= filtfilt(qqq,1,X(:,:,j));
end
t=ipermute(temp,[2 1 3]);
% t=ipermute(X,[2 1 3]);
[W training]=First_BCI(t,Y);

load('Competition_test.mat')
X=permute(X,[3 2 1]);temp=[];
parfor j=1:100
temp(:,:,j)= filtfilt(qqq,1,X(:,:,j));
end
X=ipermute(temp,[2 1 3]);
% X=ipermute(X,[2 1 3]);
sample=[];
for i=1:size(X,3)   
       C2= W'*X(:,:,i);
   C2=var(C2,0,2)';
 t=sum(C2);
 C2=log(C2/t);
 sample=[sample; C2];
end

[ldaClass,err,P,logp,coeff] = classify(sample,training,Y,'quadratic');
load('trueLabel.mat');
ddd=[ldaClass-trueLabel];
100-length(find(ddd))
beep