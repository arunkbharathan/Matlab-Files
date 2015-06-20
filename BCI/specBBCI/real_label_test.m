clc;clear all;close all
Fs=1000;c=zeros(1,511);
stp=[4 45]/Fs;
c= fir1(510,[stp(1) stp(2)]);



load('Competition_train.mat')
X=permute(X,[3 2 1]);
parfor j=1:278
X(:,:,j)= filter(c,1,X(:,:,j));
end
X=ipermute(X,[2 1 3]);
[W training]=First_BCI(X,Y);

load('Competition_test.mat')
X=permute(X,[3 2 1]);
parfor j=1:100
X(:,:,j)= filter(c,1,X(:,:,j));
end
X=ipermute(X,[2 1 3]);

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