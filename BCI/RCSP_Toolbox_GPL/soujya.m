%function CSPMatrix = learn_CCSP2(targetSubjectEEGSignals, OtherSubjectsEEGSignals, beta)
%
% <The RCSP (Regularized Common Spatial Pattern) Toolbox.>
%     Copyright (C) 2010  Fabien LOTTE
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%this function learn a CCSP1 (Composite Common Spatial Patterns method 2)
%as proposed by H. Kang et al (IEEE Signal Processing Letters "Composite
%Common Spatial Pattern for Subject-to-Subject Transfer" vol 16, no 8, 2009)
%CCSP method 2 is the matrix regularization method which weighs
%covariance matrices of other subjects according to their Kullback-Leibler
%divergence with the target subject matrix
%
%Input:
%targetSubjectEEGSignals: the training EEG signals for the target subject, composed of 2 classes. These signals
%are a structure such that:
%   targetSubjectEEGSignals.x: the EEG signals as a [Ns * Nc * Nt] Matrix where
%       Ns: number of EEG samples per trial
%       Nc: number of channels (EEG electrodes)
%       nT: number of trials
%   targetSubjectEEGSignals.y: a [1 * Nt] vector containing the class labels for each trial
%   targetSubjectEEGSignals.s: the sampling frequency (in Hz)
%OtherSubjectsEEGSignals: a cell array with the training EEG signals for
%   each other subject available (one per cell). The data structure is the 
%   same as above (for each cell)
%beta: regularization parameter (between 0 and 1). The higher beta,
%   the more the covariance matrices are shrunk towards the generic model
%   (i.e., towards the composite covariance matrix made from all other subjects matrices)
%
%Output:
%CSPMatrix: the learnt CSP filters (a [Nc*Nc] matrix with the filters as rows)
%
%by Fabien LOTTE (fprlotte@i2r.a-star.edu.sg)
%created: 07/04/2010
%last revised: 07/04/2010
%
%See also: extractCSPFeatures
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\CSP_Algorithms\CSP\';

addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\CSP_Algorithms\';
 addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\LDA_Classification\';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\RCSP_Toolbox_GPL\Utilities\';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\RCSP_Toolbox_GPL\EEG_Data\ReadingDataCode\';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\bcilab-1.0\code\misc';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\bcilab-1.0\code\filters';


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


%check and initializations
nbChannels = size(targetSubjectEEGSignals.x,2);
nbTrials = size(targetSubjectEEGSignals.x,3);
classLabels = unique(targetSubjectEEGSignals.y);
nbClasses = length(classLabels);
nbSubjects = length(OtherSubjectsEEGSignals);
if nbClasses ~= 2
    disp('ERROR! CSP can only be used for two classes');
    return;
end
%nbClassTrialsTarget = zeros(nbClasses,1); %number of trials per class for the target subject
%nbClassTrialsOther = zeros(nbClasses,nbSubjects); %number of trials per class for each other subject available

%building the covariance matrices for the target subject
covMatrices = cell(nbClasses,nbSubjects+1); %the covariance matrices for each class

%computing the normalized covariance matrices for each trial
trialCov = zeros(nbChannels,nbChannels,nbTrials);
for t=1:nbTrials
    E = targetSubjectEEGSignals.x(:,:,t)';
    EE = E * E';
    trialCov(:,:,t) = EE ./ trace(EE);
end
clear E;
clear EE;

%computing the covariance matrix for each class
for c=1:nbClasses      
    %nbClassTrialsTarget(c) = sum(targetSubjectEEGSignals.y == classLabels(c));
    covMatrices{c,1} = sum(trialCov(:,:,targetSubjectEEGSignals.y == classLabels(c)),3); 
    %covMatrices{c,1} = covMatrices{c,1} ./ sum(targetSubjectEEGSignals.y == classLabels(c)); %IS THIS NECESSARY? TO CHECK !!
end

%building the covariance matrices for the other subjects
for s=1:nbSubjects
    nbTrialsOther = size(OtherSubjectsEEGSignals{s}.x,3);    
    %computing the normalized covariance matrices for each trial
    trialCov = zeros(nbChannels,nbChannels,nbTrialsOther);
    for t=1:nbTrialsOther
        E = OtherSubjectsEEGSignals{s}.x(:,:,t)';
        EE = E * E';
        trialCov(:,:,t) = EE ./ trace(EE);
    end
    clear E;
    clear EE;

    %computing the covariance matrix for each class
    for c=1:nbClasses    
        %nbClassTrialsOther(c,s) = sum(OtherSubjectsEEGSignals{s}.y == classLabels(c));
        covMatrices{c,s+1} = sum(trialCov(:,:,OtherSubjectsEEGSignals{s}.y == classLabels(c)),3); 
        %covMatrices{c,s+1} = covMatrices{c,s+1} ./ sum(OtherSubjectsEEGSignals{s}.y == classLabels(c)); %IS THIS NECESSARY? TO CHECK !!
    end
end

%computing the Kullback-Leibler (KL) divergence between the target subject
%matrix and the other subject matrix
KLDiv = zeros(nbClasses,nbSubjects);
Ck = covMatrices{c,1};
for s=1:nbSubjects
    for c=1:nbClasses
        Cj = covMatrices{c,s+1};
        KLDiv(c,s) = 0.5 * (log(det(Ck)/det(Cj)) + trace(inv(Ck)*Cj) - size(Ck,1));
    end
end
      
%computing the generic covariance matrix for each class by weighting
%covariance matrices according to the KL-divergence with the target subject
%matrix
normTerm = sum(1 ./ KLDiv,2); %normalization term
genCovMatrices=cell(nbClasses,1);
genCovMatrices{1} = zeros(size(Ck));
genCovMatrices{2} = zeros(size(Ck));
for s=1:nbSubjects
    for c=1:nbClasses        
        %weighing the other subject matrix using the KL-divergence  
        coeff = (1 / normTerm(c)) * (1/KLDiv(c,s));
        if(isinf(KLDiv(c,s))) 
            coeff = 0; %to deal with infinite KL-divergence
        end        
        genCovMatrices{c} = genCovMatrices{c} + (coeff * covMatrices{c,s+1});
    end
end

%computing the regularized covariance matrices
covMatricesReg = cell(nbClasses,1); 
for c=1:nbClasses     
    covMatricesReg{c} = ((1-beta)*covMatrices{c,1}) + (beta*genCovMatrices{c});
end

%computing the matrix M to be decomposed
M = inv(covMatricesReg{2}) * covMatricesReg{1};

%eigen value decomposition of matrix M
[U D] = eig(M);
eigenvalues = diag(D);
[eigenvalues egIndex] = sort(eigenvalues, 'descend');
U = U(:,egIndex);
CSPMatrix = U';