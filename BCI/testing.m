clc;clear all;
load Competition_train.mat
wn=[0.08/5,0.08];[b,a]=butter(6,wn);
for i=1:278
    for j=1:64
        a1=X(i,j,:);
        b1=filtfilt(b,a,a1);
        newX(i,j,:)=b1;
    end;end;
for i=1:278
    for j=1:64
        a2=newX(i,j,:);
        b2=downsample(a2,10);
        newnewX(i,j,:)=b2;
    end;end;
size(newnewX)