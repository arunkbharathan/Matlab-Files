function[res]=newBCItest(X,curmodel)
% load('Competition_test.mat');
X=permute(X,[2 3 1]);Fs=1000;
L=10;
S=reducedFs(X,L);
Fs=100;X=S;
  % load('FIL5_35Competition_test.mat');
  tmwin=[0 3];frwin=[5 35];
%  AMean=mean(S,2);
%  AStd=std(S,0,2);
%  X=0;
%  S = (S - repmat(AMean,[1 3000 1])) ./ repmat(AStd,[1 3000 1]);
 
% % parfor t=1:size(S,3)
% % X(:,:,t) = cov(S(:,:,t)');
% % end
% % Ep=sum(X,3)/size(X,3);
%   
regions=cell(1,size(frwin,1));
for r = 1:(size(frwin,1))
    reg.S=cutEEG(X,tmwin(r,1),tmwin(r,2),Fs);
    %load('FIL5_35Competition_test.mat');reg.S=S;
     reg.S=filterEEG(reg.S,frwin(r,1),frwin(r,2),Fs); 
 Scell = num2cell(reg.S,[1 2]);
 Ep = cov(cat(2,Scell{:})');
%   
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
%                  run('C:\Users\ArunKB\Documents\MATLAB\cvx\cvx\cvx_startup.m');
% %                  clc;clear;cvx_clear
%                 
%                  [W bias z] = lrl1(WC,Y,0.2);beep

 
% load('augmentWeight.mat')
y=zeros(size(WC,3),1);
   aa=[block{:}];
Y=load('trueLabel');Y=Y.trueLabel;

   for t=1:size(WC,3)
       a=aa(:,:,t);a=a(:);
     y(t) = a'*curmodel.w(:)+curmodel.b;
   end
 res=  sum(sign(y)==Y)/size(S,3)*100;
% imshow(curmodel.w);
% imshow(inv(curmodel.w))
% title('Weight Matrix')
% colormap(hot);beep