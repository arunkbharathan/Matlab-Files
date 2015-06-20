load('C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\testingEEGSignals.mat');
load('C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\EEG_Data\BCI_IV_DSIIa\trainingEEGSignals.mat');
X=permute(trainingEEGSignals{7}.x,[2 1 3]);
%X=filterEEG(X,7,30,trainingEEGSignals{7}.s);
Y=trainingEEGSignals{7}.y';
np=1;
[filters trainfeatures patterns]=RCSPBCI(X,Y,np,0,1);
idx = [1:np 2*np:-1:np+1];
load('C:\Users\ArunKB\Documents\MATLAB\BCI\RCSP_Toolbox_GPL\ChanLocs22.mat');
 for p=1:np*2
                subplot(2,np,p);
                topoplot(patterns(idx(p),:),ChanLocs22);
                title(['CSP Pattern ' num2str(idx(p))]);
 end
 figure;
 for p=1:np*2
                subplot(np,2,p);
                topoplot(filters(:,idx(p)),ChanLocs22);
                title(['CSP Filters ' num2str(idx(p))]);
 end
            [ldaClass,err,P,logp,coeff] = classify(trainfeatures,trainfeatures,Y,'linear');

            (1-err)*100
X=permute(testingEEGSignals{7}.x,[2 1 3]);
X=filterEEG(X,7,30,trainingEEGSignals{7}.s);
Y=testingEEGSignals{7}.y';
[filters testfeatures patterns]=CSPBCI(X,Y,np,filters,0);
[ldaClass,err,P,logp,coeff] = classify(testfeatures,trainfeatures,Y,'linear');
sum(ldaClass==Y)/length(ldaClass)*100
