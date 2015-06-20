load('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\FIL5_35Competition_train.mat');
  patterns=3;i=0;%filters=0;
% %  [filters2] = CSP(S,Y,patterns);
  [filters,trainfeatures] = CSPBCI(S,Y,patterns,filters,i);

%%             Y(Y==-1)=0;
%             X = LDA(features,Y);
%             L = [ones(size(features,1),1) features] * X';
            
%             L=features*FDV;
%             P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
%             [a,b]=max(P,[],2);
% b(b==1)=0;
% b(b==2)=1;
% sum(Y==b)/length(Y)*100
%%
% load('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\trueLabel.mat');%Y=trueLabel; Y(Y==-1)=0;
% load('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\FIL5_35Competition_test.mat');
% signal.data=S;
% testfeatures = zeros(size(signal.data,3),size(featuremodel.filters,2));
%             for t=1:size(signal.data,3)
%                 testfeatures(t,:) = log(var(signal.data(:,:,t)'*featuremodel.filters)); 
%             end
%%              L = [ones(size(features,1),1) features] * X';
%             P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
%             [a,b]=max(P,[],2);
% b(b==1)=0;
% b(b==2)=1;
% sum(Y==b)/length(Y)*100
%%
load('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\trueLabel.mat');%Y=trueLabel; Y(Y==-1)=0;
load('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\FIL5_35Competition_test.mat');
patterns=3;i=0;
[filters,testfeatures] = CSPBCI(S,trueLabel,patterns,filters,i);
% [ldaClass,err,P,logp,coeff] = classify(trainfeatures,trainfeatures,Y,'linear');
% (1-err)*100
% 
% [ldaClass,err,P,logp,coeff] = classify(testfeatures,trainfeatures,Y,'linear');
% sum(ldaClass==trueLabel)/length(ldaClass)*100

obj = ClassificationDiscriminant.fit(trainfeatures,Y);
(1-resubLoss(obj)) * 100
R = confusionmat(obj.Y,resubPredict(obj))
cvmodel = crossval(obj,'kfold',5);
cverror = kfoldLoss(cvmodel);
(1-cverror)*100
% [err,gamma,delta,numpred] = cvshrink(obj,...
%     'NumGamma',29,'NumDelta',29,'Verbose',1);
% figure;
% plot(err,numpred,'k.')
% xlabel('Error rate');
% ylabel('Number of predictors');
% minerr = min(min(err));
% [p,q] = find(err == minerr)
% % [gamma(p(1)),delta(p(1),q(1))]
% % [gamma(p(2)),delta(p(2),q(2))]
% % numpred(p(1),q(1))
% % numpred(p(2),q(2))
% low250 = min(min(err(numpred <= patterns)))
% lownum = min(min(numpred(err == low250)))
% [r,s] = find((err == low250) & (numpred == lownum));
% gamma(r);
% %  r=0.5833;s=0.5978;
obj.Gamma =  0.3103;
obj.Delta = 0.5390;
sum(trueLabel==predict(obj,testfeatures))

