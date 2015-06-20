function [ind]=covchkChannel(avg1,avg2)
% clc;clear;load('Competition_train.mat');X=shiftdim(X,1);
A=avg1;d=[];
 C(:,:,1)=A;%-repmat(mean(A')',[1 3000]);
B=avg2;
C(:,:,2)=B;%-repmat(mean(B')',[1 3000]);;
for i=1:64
k=cov(squeeze(C(i,:,:)));
d=[d; k(2)];
end
d=abs(d);
[val ind]=sort(d,'descend');
e=[val ind];