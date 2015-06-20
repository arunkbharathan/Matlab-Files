clc;clear;load('FIL5_35Competition_train.mat');
%   C=[46 47 55 63];
C=[1:64];
  f=3:38;
  h=fspecial('laplacian',.01);
  S=imfilter(S, h);
  S=S(C,:,:);
% eeg.srate=1000;
dBc=zeros(length(C),length(f),size(S,3));
tic
for c=1:length(C)
 for i=f
    for j=1:size(S,3)
dBc(c,i,j) = bandpower(S(c,:,j),1000,[i-1 i+1]);
    end
 end
end
toc
beep
%  load('dBc5_35.mat');
 score_c_F=zeros(length(C),size(dBc,2));tmp=zeros(2);
  for c=1:length(C)
   for i=f
     tmp = corrcoef(squeeze(dBc(c,i,:)),Y);
     score_c_F(c,i)=tmp(2);
   end
  end
%   score_c_F=score_c_F(:,[14:38])
  [~,Fmax]=max(sum(score_c_F));
  
  for c=1:length(C)
      if(score_c_F(c,Fmax)<+0)
      score_c_F(c,:)=-score_c_F(c,:);
      end
  end
  
  fscore = sum(score_c_F);
  [~,Fmax] = max(fscore)
  f0=Fmax;f1=Fmax;
  while fscore(f0-1)>=fscore(Fmax)*0.3
      f0=f0-1;
  end
  while fscore(f1+1)>=fscore(Fmax)*0.3
      f1=f1+1;
  end
  [f0 f1]
  %7 11 15 20