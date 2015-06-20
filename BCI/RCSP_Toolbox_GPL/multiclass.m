 
 
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\CSP_Algorithms\CSP\';

addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\CSP_Algorithms';
 addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\LDA_Classification';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\RCSP_Toolbox_GPL\Utilities';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\RCSP_Toolbox_GPL\EEG_Data\ReadingDataCode';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\bcilab-1.0\code\misc';
addpath 'C:\Users\ArunKB\Documents\MATLAB\BCI\bcilab-1.0\code\filters';
% addpath 'F:\MTECH\final project\eeglab12_0_1_0b\functions\popfunc\';
  nbFilterPairs=3;
%   read_BCI_IV_DSIIa()
%    load 'F:\MTECH\final project\bci code\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\trainingEEGSignals.mat'
%     load 'F:\MTECH\final project\bci code\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\testingEEGSignals.mat'  
    voted=cell(4,4,9);
    accuracy=cell(4,4,9);
    nbSubjects=9
    %bestalpha
%     for i=1:4
%             for j=i+1:4
% for s=1:nbSubjects
%     read_BCI_IV_DSIIa([i j])
%    load 'F:\MTECH\final project\bci code\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\trainingEEGSignals.mat'
%     load 'F:\MTECH\final project\bci code\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\testingEEGSignals.mat'
%     nbSubjects = length(trainingEEGSignals);
%     trainingEEGSignals{s} = eegButterFilter(trainingEEGSignals{s}, 8, 30, 5);
%     testingEEGSignals{s} = eegButterFilter(testingEEGSignals{s}, 8, 30, 5);
%     alphaExp = 10:-1:1;
% alphaList = [10.^-alphaExp 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
%  k = 10;
%  bestAlpha = TRSPECCSPWithBestParams(trainingEEGSignals{s}, alphaList, k, nbFilterPairs,i,j); 
%     aw(s)=bestAlpha;
% end
%             end
%     end
    
    
for i=1:4
            for j=i+1:4
                % learn an i-vs-j model
                % get trial subset
%                 subset = trainingEEGSignals{s}.y  == i | trainingEEGSignals{s}.y  == j;
%                 trainingEEGSignals{s}.x=trainingEEGSignals{s}.x(:,:,subset);
%                 subset = trainingEEGSignals{s}.y  == i | trainingEEGSignals{s}.y  == j;
%                 testingEEGSignals{s}.x=testingEEGSignals{s}.x(:,:,subset);
           read_BCI_IV_DSIIaSPEC([i j])
   load 'F:\MTECH\final project\bci code\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\trainingEEGSignals.mat';
    load 'F:\MTECH\final project\bci code\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\testingEEGSignals.mat';
%    
   % accuracy = zeros(1,nbSubjects);

nbFilterPairs = 3; %we use 3 pairs of filters
%parameters for band pass filtering the signals in the mu+beta band (8-30 Hz)
low = 8;
high = 30;
order = 5; %we use a 5th-order butterworth filter

%variables to compute the computation time
trainingTime = zeros(nbSubjects,1);terPairs = 3; %we use 3 pairs of filters


for s=1:nbSubjects
    %getSubDataSet(dataSet, trialIndexes)
%      % get trial subset
%  a=[1:288];    
%                 subset = trainingEEGSignals{s}.y  == i | trainingEEGSignals{s}.y  == j;
%                 a=a(:,subset);
%                 trainingEEGSignals{s}=getSubDataSet(trainingEEGSignals{s}, a)
%                 subset = trainingEEGSignals{s}.y  == i | trainingEEGSignals{s}.y  == j;
%                 a=[1:288];
%                 a=a(:,subset);
%                 testingEEGSignals{s}=getSubDataSet(trainingEEGSignals{s}, subset)
%     trainingEEGSignals{s} = eegButterFilter(trainingEEGSignals{s}, low, high, order);
%     testingEEGSignals{s} = eegButterFilter(testingEEGSignals{s}, low, high, order);
%end
%for s=1:nbSubjects    
    %Learning the Regularized CSP filters, depending on the algorithm chosen
    tic; %to evaluate the learning time
   
    %change sampling rate
   
%   trainingEEGSignals{s}.x=upsample( trainingEEGSignals{s}.x,2);
%   trainingEEGSignals{s}.x=downsample( trainingEEGSignals{s}.x,5);
%    testingEEGSignals{s}.x=upsample(  testingEEGSignals{s}.x,2);
%   testingEEGSignals{s}.x=downsample( testingEEGSignals{s}.x,5);
 % testingEEGSignals{s}.x=sample( testingEEGSignals{s.x},5,2);
%    trainingEEGSignals{s} = flt_fir(trainingEEGSignals{s},[6 8 28 30],'minimum-phase');
%     testingEEGSignals{s} = flt_fir(testingEEGSignals{s},[6 8 28 30],'minimum-phase')
     trainingEEGSignals{s} = eegButterFilter(trainingEEGSignals{s}, 8, 30, 5);
     testingEEGSignals{s} = eegButterFilter(testingEEGSignals{s}, 8, 30, 5);
      
     %For TRSPECCSP
      alphaExp = 10:-1:1;
   alphaList = [10.^-alphaExp];
    k = 8;
    bestAlpha = TRSPECCSPWithBestParams(trainingEEGSignals{s}, alphaList, k, nbFilterPairs,i,j); 
       aw(s)=bestAlpha;
    otherSubjects = [1:(s-1) (s+1):nbSubjects];
    
    disp('Learning CSP filters assuming invertible covariance matrices');
%     
bestAlpha=aw(s);
       CSPMatrix = TRSpeccsp(trainingEEGSignals{s},i,j,bestAlpha);
         %CSPMatrix = Speccsp(trainingEEGSignals{s},i,j);
        trainingTime(s) = toc;
        

                % learn restricted model
                %CSPMatrix = learnCSPLagrangian(trainingEEGSignals{1});
                        % feature vectors
                         %extracting CSP features from the training set
    trainFeatures = extractCSPFeatures(trainingEEGSignals{s}, CSPMatrix, nbFilterPairs);
    
    %training a LDA classifier on these features
    ldaParams = LDA_Train(trainFeatures);
     %extracting CSP features from the testing set
    testFeatures = extractCSPFeatures(testingEEGSignals{s}, CSPMatrix, nbFilterPairs);
    
    %classifying the test features with the learnt LDA
    result = LDA_Test(testFeatures, ldaParams);    
    accuracy{i,j,s} = result.accuracy;
          voted{i,j,s} =  struct('fetures',  trainFeatures, 'ldapara',ldaParams,'csp',CSPMatrix,'result',result)              
end     

                
            end
        end