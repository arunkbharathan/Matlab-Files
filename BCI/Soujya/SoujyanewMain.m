% clear
% addpath('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\');%passBand.low=7;passBand.high=30;
% 
% % read_BCI_IV_DSIIa([1 2], passBand);
% load('C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\EEG_Data\BCI_III_DSIVa\trainingEEGSignals.mat');
% load('C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\EEG_Data\BCI_III_DSIVa\testingEEGSignals.mat');
% load('C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\ChanLocs118.mat');
result=[];
for i=1:1
Y=trainingEEGSignals{i}.y';
S=permute(trainingEEGSignals{i}.x,[2 1 3]);
classes=unique(Y);yy=Y;
Y(classes(1)==yy)=1;
Y(classes(2)==yy)=-1;
  patterns=2;filters=0;
[filters,features] = CSPBCI(S,Y,patterns,filters,1);
global  Cf Ch Csum  Ew1 Ew2
TperE=5;
        C1=S(:,:,Y==1);
        C2=S(:,:,Y==-1);
 Scell = num2cell(C1,[1 2]);
 E1T = cov([Scell{:}]');
 Scell = num2cell(C2,[1 2]);
 E2T = cov([Scell{:}]');
 Ew1=buildEpochsofTrialsCov(C1,TperE);
 Ew2=buildEpochsofTrialsCov(C2,TperE);
Ew1=cell2mat(Ew1);
Ew1=reshape(Ew1,size(S,1),size(S,1),[]);
Ew2=cell2mat(Ew2);
Ew2=reshape(Ew2,size(S,1),size(S,1),[]);
Cf=E1T;
Ch=E2T;
Csum=E1T+E2T;
clear Scell TperE C1 C2 E1T E2T
w=filters(:);
tic;[abc,fval]=untitled8(w,1e10,1e10);toc
beep;abcc=[abc(1:118) abc(119:236) abc(237:354) abc(355:472) ];%abc(129:192) abc(193:256) abc(257:320) abc(321:384)];
 filters=abcc;fval;
[~,trainfeatures] = CSPBCI(S,Y,patterns,filters,0);
obj = ClassificationDiscriminant.fit(trainfeatures,Y);
cvmodel = crossval(obj,'kfold',5);
cverror = kfoldLoss(cvmodel);
tra=(1-cverror)*100;
R = confusionmat(obj.Y,resubPredict(obj))

% [err,gamma,delta,numpred] = cvshrink(obj,...
%     'NumGamma',29,'NumDelta',29,'Verbose',0);
% 
% minerr = min(min(err));
% [p,q] = find(err == minerr);
% low250 = min(min(err(numpred <= patterns)));
% lownum = min(min(numpred(err == low250)));
% [r,s] = find((err == low250) & (numpred == lownum));
% obj.Gamma =  gamma(r(end));
% obj.Delta = delta(r(end),s(end));



Y=testingEEGSignals{i}.y';
S=permute(testingEEGSignals{i}.x,[2 1 3]);
classes=unique(Y);yy=Y;
Y(classes(1)==yy)=1;
Y(classes(2)==yy)=-1;
[~,testfeatures] = CSPBCI(S,Y,patterns,filters,0);
res=sum(Y==predict(obj,testfeatures))/length(Y)*100;
result=[result;i res tra]
end