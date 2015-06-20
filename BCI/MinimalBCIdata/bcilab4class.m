
clc;clear;close all;clc
traindata = io_loadset('A01T.gdf');




myapproach1 = {'CSP' 'SignalProcessing',{'EpochExtraction',[0.5 3.5],'FIRFilter',[7 8 26 28]}};
myapproach2 = {'SpecCSP' 'SignalProcessing',{'EpochExtraction',[0.5 3.5]}};
myapproach3 = {'CSP' 'Prediction',{'FeatureExtraction',{'PatternPairs',search(1,2,3)}}};
myapproach4 = {'CSP' 'Prediction',{'MachineLearning',{'Learner','logreg'}},'SignalProcessing',{'EpochExtraction',[0.5 3.5],'FIRFilter',[7 8 26 28]}};
% learn a predictive model
[trainloss,lastmodel,laststats] = bci_train('Data',traindata,'Approach',myapproach1,'TargetMarkers',{'769','770','771','772'}); 
 
trainloss
% visualize results
bci_visualize(lastmodel)


%% --- applying the CSP model to some data (here: same data) ---

% apply the previously learned model to a data set (querying it for each target marker in the data)
[prediction,loss,teststats,targets] = bci_predict(lastmodel,traindata);

% display the results
disp(['training mis-classification rate: ' num2str(trainloss*100,3) '%']);
disp(['test mis-classification rate: ' num2str(loss*100,3) '%']);
disp(['  predicted classes: ',num2str( prediction{3}(argmax(prediction{2}'))')]);  % class probabilities * class values
disp(['  true classes     : ',num2str(round(targets)')]);


testdata = io_loadset('A01E.gdf')
    
    prediction = bci_predict(lastmodel, testdata,'TargetMarkers', {'783'});
disp(['  predicted classes: ',num2str( prediction{3}(argmax(prediction{2}'))')]); 
[predictions,latencies] = onl_simulate(traindata,lastmodel,'markers', {'783'},'offset',3)