clc;clear;Fs=1000;
d = fdesign.hilbert('TW,Ap',1,0.1,Fs);
hd = design(d,'equiripple');
% fvtool(hd,'magnitudedisplay','zero-phase', ...
% 'frequencyrange','[-Fs/2, Fs/2)');
load('FIL5_35Competition_train.mat');
S=cat(2,S,zeros(size(S,1),1400,size(S,3)));
C=[46 47 55 63];
S=S(C,:,:);
S=permute(S,[2 1 3]);
for i=1:size(S,3)
    S(:,:,i)=filter([.5 .5],1,filter(hd,S(:,:,i)));
end
S=ipermute(S,[2 1 3]);beep;S=S(:,1321:4320,:);
score_c_T=zeros(length(C),size(S,2));tmp=zeros(2);
for c=1:length(C)
    for tym=1:size(S,2)
       tmp = corrcoef(S(c,tym,:),Y);
       score_c_T(c,tym)=tmp(2);
    end
end
[~,Tmax] = max(sum(abs(score_c_T)))
for c=1:length(C)
      if(sum(score_c_T(c,Tmax-Fs*.1:Tmax+Fs*.1))<=0)
      score_c_T(c,:)=-score_c_T(c,:);
      end
end

tscore=sum(score_c_T);
[~,Tmax]=max(tscore)
thresh = 0.09*sum(tscore(tscore>0));
t0=Tmax;t1=Tmax;
while sum(tscore(t0:t1))<thresh
    if sum(tscore(1:t0-1))>sum(tscore(t1+1:end))
        t0=t0-1;
    else
        t1=t1+1;
    end
    
end
[t0 t1]
