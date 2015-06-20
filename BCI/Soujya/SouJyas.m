clear
load('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\FIL5_35Competition_train.mat');
global  Cf Ch Csum  Ew1 Ew2
% X=permute(X,[2 3 1]);
% Fs=1000;
TperE=5;
%     S=filterEEG(X,5,35,Fs); 
%     clear X;
        C1=S(:,:,Y==1);
        C2=S(:,:,Y==-1);
 Scell = num2cell(C1,[1 2]);
 E1T = cov([Scell{:}]');
 Scell = num2cell(C2,[1 2]);
 E2T = cov([Scell{:}]');
 Ew1=buildEpochsofTrialsCov(C1,TperE);
 Ew2=buildEpochsofTrialsCov(C2,TperE);
%  L= SoujLossFcn(w,E1T,E2T,Ew1,Ew2);
Ew1=cell2mat(Ew1);
Ew1=reshape(Ew1,64,64,[]);
Ew2=cell2mat(Ew2);
Ew2=reshape(Ew2,64,64,[]);
Cf=E1T;
Ch=E2T;
Csum=E1T+E2T;
clear S Scell Y TperE C1 C2 E1T E2T
