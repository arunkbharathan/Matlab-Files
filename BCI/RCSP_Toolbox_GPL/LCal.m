% function L=KL divergence(EEGSignals)
read_BCI_IV_DSIIa([1 2])
load 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\trainingEEGSignals.mat'
load 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\testingEEGSignals.mat'
 d=3;
nbChannels=22;
nbTrials=288;
% nbClasses=2;
classLabels=[1,2];
trialCov = zeros(nbChannels,nbChannels,nbTrials);
nbClasses = length(classLabels);
 %computing the covariance matrix for each class     
for c=1:nbClasses 
  covMatrices{c} = mean(trialCov(:,:,trainingEEGSignals.y == classLabels(c)),3); 
  covMatrices{c} = covMatrices{c} ./ sum(trainingEEGSignals.y == classLabels(c));
    %computing the normalized covariance matrices for each trial
    D=0;
for t=1:nbTrials
    E = EEGSignals.x(:,:,t)';
    EE = E * E';
    trialCov(:,:,t) = EE ./ trace(EE);
    D(t)=.5*[trace(inv(covMatrices{c}).*trialCov(:,:,t))-log(det(trialCov(:,:,t))/det(covMatrices{c}))-d]; 
    D=.5*(D+D(t));
end
D(c)=D/nbTrials;
L=0;
L(c)=.5*D(c);
L=L+L(c);
end



