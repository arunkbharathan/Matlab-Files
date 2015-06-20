clc;clear;close all;clc
% run('C:\Users\ArunKB\Documents\MATLAB\BCI\bcilab-1.0\bcilab');

traindata = io_loadset('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\Competition_train.mat');
myapproach2 = {'SpecCSP' 'SignalProcessing',{'EpochExtraction',[0.5 3],'FIRFilter',[6 8 28 30]}};
[trainloss,lastmodel,laststats] = bci_train('Data',traindata,'Approach',myapproach2,'TargetMarkers',{'-1','1'}); 