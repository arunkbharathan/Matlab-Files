clc;clear
load('data_set_IVb_al_train.mat')
mydata=cnt';
mysrate=nfo.fs;
mychannels=nfo.clab;
mrk.y(mrk.y==-1)=2;
myeventtypes=cellstr(num2str(mrk.y'))';
myeventlatencies=cellstr(num2str(mrk.pos'))';
traindata = exp_eval(set_new('data',mydata, 'srate',mysrate,...
'chanlocs',struct('labels',mychannels),...
'event',struct('type',myeventtypes','latency',myeventlatencies')));
pop_saveset(traindata)
