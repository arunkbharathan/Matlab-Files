%% --- tutorial script for spectral analysis ---

% This tutorial demonstrates the use of BCILAB to learn basic predictive models using 
% spectral properties of the data, here operating on motor cortex idle oscillations.
%
% The used data set contains a sequence of trials in which a subject was instructed to imagine
% moving either the left hand or the right hand. Markers in the data set indicate the timing and 
% type of these instructions (types are: 'StimulusCode_2' and 'StimulusCode_3').
%
% Notes: StimulusCode_1 indicates onset of a "resting" / "relaxing" condition.
%
% Data courtesy of Romain Grandchamp, CERCO, Toulouse, France. Reference:
%   Romain Grandchamp, Arnaud Delorme, "NeuroTRIP: A Framework for Bridging between Open Source Software. Application to Training a Brain Machine Interface," 
%   Fifth International Conference on Signal Image Technology and Internet Based Systems, pp.451-457, 2009
%
%#ok<*ASGLU,*NASGU,*SNASGU> % turn off a few editor warnings...

%% --- using the Common Spatial Pattern method ---

% load the data set (BCI2000 format)
clc;clear;close all;clc
traindata = io_loadset('data_set_IVb_al_train.mat');
traindata = set_insert_markers(traindata, 'SegmentSpec',{'1',5,-3,'-1'},'Count',2,'Event','0')
   traindata = set_insert_markers(traindata, 'SegmentSpec',{'-1',5,-3,'1'},'Count',2,'Event','0')


%% --- using the Common Spatial Pattern method with some custom options ---



% define the approach 
% Note: The settings found in the GUI "Review/Edit Approach" Panel can be translated literally
%       into cell array representations as below. Each paradigm has a few top-level parameter groups
%       (for CSP: SignalProcessing, FeatureExtraction, etc), which in turn have sub-parameters
%       (e.g., SignalProcessing has EpochExtraction, SpectralSelection, Resampling, etc.), and so
%       on. Some parameters are numbers, strings, cell arrays, etc. You only need to specify those 
%	    parameters where you actually want to deviate from the paradigm's defaults.
%
% For illustratory purposes, we use a different window relative to the target markers (0.5s to 3s after),
% and a somewhat customized FIR frequency filter with a pass-band between ~7.5Hz and ~27Hz.
myapproach1 = {'CSP' 'SignalProcessing',{'EpochExtraction',[0.5 3],'FIRFilter',[7 8 26 28]}};
myapproach2 = {'SpecCSP' 'SignalProcessing',{'EpochExtraction',[0.5 3]}};
myapproach3 = {'CSP' 'Prediction',{'FeatureExtraction',{'PatternPairs',search(1,2,3)}}};
myapproach4 = {'CSP' 'Prediction',{'MachineLearning',{'Learner','logreg'}},'SignalProcessing',{'EpochExtraction',[0.5 3],'FIRFilter',[7 8 26 28]}};
% learn a predictive model
[trainloss,lastmodel,laststats] = bci_train('Data',traindata,'Approach',myapproach1,'TargetMarkers',{'1','-1','0'}); 
trainloss
% visualize results
bci_visualize(lastmodel)


%% --- applying the CSP model to some data (here: same data) ---

% apply the previously learned model to a data set (querying it for each target marker in the data)
[prediction,loss,teststats,targets] = bci_predict(lastmodel,traindata);

% display the results
disp(['training mis-classification rate: ' num2str(trainloss*100,3) '%']);
disp(['test mis-classification rate: ' num2str(loss*100,3) '%']);
disp(['  predicted classes: ',num2str(round(prediction{2}*prediction{3})')]);  % class probabilities * class values
disp(['  true classes     : ',num2str(round(targets)')]);






%% --- test the learned model in simulated real-time processing ---
% ( click into the figure to stop the update (and make sure that your click was registered) )

% load feedback session
testdata = io_loadset('data_set_IVb_al_test.mat');

% play it back in real time
run_readdataset('Dataset',testdata);

% process data in real time using lastmodel, and visualize outputs
run_writevisualization('Model',lastmodel, 'VisFunction','bar(y)');

% make sure that the online processing gets terminated...
disp('Click into the figure to stop online processing.'); 
waitforbuttonpress; onl_clear; close(gcf);

% dataset = bci_annotate(lastmodel,testdata)
% pop_eegplot(dataset)