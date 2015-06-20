
clc;clear;close all;clc
% run('C:\Users\ArunKB\Documents\MATLAB\BCI\bcilab-1.0\bcilab');
dataset=7;
traindata = io_loadset(['A0' num2str(dataset) 'T.gdf'],'channels',1:22);
% [Signal,State] = exp_eval_optimized(flt_eog(traindata))
%EOG remove
% traindata = flt_eog(traindata,{'EOG-left','EOG-central','EOG-right'});

% use a 1Hz highpass filter (with very generous transition region) that is linear phase (i.e.
% does not distort the signal)
%traindata = flt_fir(traindata,[6 8 28 32],'bp','minimum-phase');

% select channels 1:22
%traindata = flt_selchans(traindata,1:22);
myapproach9={'RCSP'};myapproach10={'DALOSC'};
myapproach8={'DAL'  'SignalProcessing',{'EpochExtraction',[.5 3.5]},'Prediction',{'FeatureExtraction',{'WindowFreqs', ...
    [7 13;15 20],'WindowTimes',[.6 1;1.5 2]},'MachineLearning',{'Learner',{'dal','lambdas',[1:2],'LossFunction','logistic','Regularizer','ds'}}}}%.^(1:-0.33:-6)}}}};
myapproach7={'DALOSC' 'SignalProcessing',{'EpochExtraction',[0.5 3.5],'FIRFilter',[6 8 28 30]},'Prediction',{'MachineLearning',{'Learner',{'dal','lambdas',2,'LossFunction','logistic','Regularizer','ds'}}}}%.^(1:-0.33:-6)}}}};
myapproach1 = {'CSP' 'SignalProcessing',{'EpochExtraction',[0.5 4.1],'FIRFilter',[6 8 28 30]},'Prediction',{'FeatureExtraction',{'PatternPairs',3},'MachineLearning',{'Learner',{'rvm'}}}};
%myapproach2 = {'SpecCSP' 'SignalProcessing',{'EpochExtraction',[0.6 4.1],'FIRFilter',[6 8 28 30]},'Prediction',{'FeatureExtraction',{'PatternPairs',3},'MachineLearning',{'Learner',{'logreg','variant','l1','lambda',search(2.^(-6:1.5:10))}}}};
myapproach2 = {'SpecCSP' 'SignalProcessing',{'EpochExtraction',[0.5 4.1],'FIRFilter',[6 8 28 30]}};
myapproach3 = {'FBCSP' 'SignalProcessing',{'EpochExtraction',[0.5 4.1],'FIRFilter',[6 8 28 30]}};
myapproach4 = {'RCSP' 'Prediction',{'MachineLearning',{'Learner','logreg'}},'SignalProcessing',{'EpochExtraction',[0.5 3.5],'FIRFilter',[7 8 26 28]}};
myapproach5 = {'CSP' 'SignalProcessing',{'EpochExtraction',[0.5 3.5],'FIRFilter',[6 8 28 30],'StationarySubspace',{'StationaryDim',-0.1,'Operation','keep_stationary'}},'Prediction',{'FeatureExtraction',{'PatternPairs',3}}};
myapproach6 =  {'DAL' 'SignalProcessing',{'EpochExtraction',{'TimeWindow',[0.5 4.1]}}};
approaches1= {'CSP' 'Prediction',{'MachineLearning',{'Learner',{'rvm','kernel','rbf','gamma',1}}}};
% learn a predictive model
[trainloss,lastmodel,laststats] = bci_train('Data',traindata,'Approach',myapproach9,'TargetMarkers',{'769','770','771','772'}); 
beep 
bci_visualize(lastmodel)
trainloss
%visualize results
%bci_visualize(lastmodel)


%% --- applying the CSP model to some data (here: same data) ---

% apply the previously learned model to a data set (querying it for each target marker in the data)
[prediction,loss,teststats,targets] = bci_predict(lastmodel,traindata);

% display the results
disp(['training mis-classification rate: ' num2str(trainloss*100,3) '%']);
disp(['test mis-classification rate: ' num2str(loss*100,3) '%']);
 disp(['  predicted classes: ',num2str(round(prediction{2}*prediction{3})')]);  % class probabilities * class values
disp(['  true classes     : ',num2str(round(targets)')]);


testdata = io_loadset(['A0' num2str(dataset) 'E.gdf'],'channels',1:22)
%testdata = flt_eog(testdata,{'EOG-left','EOG-central','EOG-right'});
%testdata = flt_fir(testdata,[6 8 28 32],'bp','minimum-phase');

    
Prediction = bci_predict(lastmodel, testdata,'TargetMarkers',{'783'});
PreLabels=Prediction{3}(argmax(Prediction{2}'));
TrueLabel = load(['C:\Users\ArunKB\Documents\MATLAB\BCI\Asok\A0' num2str(dataset) 'E.mat']);
Labels = getfield(TrueLabel, 'classlabel');
par='class'
RESULTS = assessment(Labels,PreLabels,par)
beep