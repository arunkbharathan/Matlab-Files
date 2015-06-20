function[curmodel]=newBCI(X,Y)
% load('Competition_train.mat');
% X=permute(X,[2 3 1]);
Fs=250;
% L=10;
% S=reducedFs(X,L);
% Fs=100;X=S;
%  load('FIL5_35Competition_train.mat');
tmwin=[0 3];frwin=[6  30];
% AMean=mean(S,2);
% AStd=std(S,0,2);
% X=0;
% S = (S - repmat(AMean,[1 3000 1])) ./ repmat(AStd,[1 3000 1]);

% parfor t=1:size(S,3)
% X(:,:,t) = cov(S(:,:,t)');
% end
% Ep=sum(X,3)/size(X,3);
regions=cell(1,size(frwin,1));
for r = 1:(size(frwin,1))
%     reg.S=cutEEG(X,tmwin(r,1),tmwin(r,2),Fs);
% %     load('FIL5_35Competition_train.mat');reg.S=S;

% reg.S=filterEEG(X,frwin(r,1),frwin(r,2),Fs); 
        reg.S=X;
 Scell = num2cell(reg.S,[1 2]);
 Ep = cov(cat(2,Scell{:})');
  
   reg.preproc = {Ep^-.5, Ep^-.5};
   [lhs, rhs]=reg.preproc {:};
   S=reg.S;
    WC = zeros(size(S,1),size(S,1),size(S,3));
                    parfor t=1:size(S,3)
                        WC(:,:,t) = lhs*cov(S(:,:,t)')*rhs;
                    end
                bs=  1/sqrt(sum(sum(var(WC,[],3)))); reg.preproc{3}=bs;
                regions{r}=reg;
end
block = cell(1,length(regions));
            for r = 1:length(regions)
                reg=regions{r};
                [lhs,rhs,bs] = reg.preproc{:};
                S=reg.S;
                 parfor t=1:size(S,3)
                        WC(:,:,t) = bs*lhs*cov(S(:,:,t)')*rhs;
                 end
                 block{r} = WC;
            end
            features = reshape([block{:}],[],size(S,3))';
            features(~isfinite(features(:))) = 0;
                 
%                  run('C:\Users\ArunKB\Documents\MATLAB\cvx\cvx_startup.m');
% %                  clc;clear;cvx_clear
%                 
%                  [W bias z] = lrl1(WC,Y,0.2);beep

% feature = reshape(WC,[],size(S,3))';
% signal=struct('filtScaleCenter',S,'whitenedCov',WC,'featureMatrix',feature,'preproc',reg.preproc);
% load('featureWCY.mat');
A=features;y=Y;lambda=5;verbose=1;solver='cg';shape=size(WC,1)*ones(length(regions),2);

curmodel = struct('w',{zeros(sum(shape(:,1).*shape(:,2)),1)},'b',{0})
addpath('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\DAL105\')
  [curmodel.w,curmodel.b] = dallrds(curmodel.w(:),curmodel.b,A,y,lambda,'display',verbose,'solver',solver,'blks',shape);
  ix = 0;
        modelrank = 0;
        for s=1:size(shape,1)
            ival = shape(s,1)*shape(s,2);
            modelrank = modelrank + rank(reshape(curmodel.w(ix+1:ix+ival),shape(s,:)));
            figure;imshow(reshape(curmodel.w(ix+1:ix+ival),shape(s,:)));colormap(hot)
            ix = ix+ival;
        end
        modelrank 
   y=zeros(size(WC,3),1);
   aa=[block{:}];


   for t=1:size(WC,3)
       a=aa(:,:,t);a=a(:);
     y(t) = a'*curmodel.w(:)+curmodel.b;
   end
   sum(sign(y)==Y)/size(S,3)*100