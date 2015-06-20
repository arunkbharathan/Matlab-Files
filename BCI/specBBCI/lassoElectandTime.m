% parallize
% load('Competition_train.mat')
% X=permute(X,[2 3 1]);
% X=reshape(X,[64 3000*278]);
% S=zeros(64,83400);for i=1:64 S(i,:)=decimate(X(i,:),10);end
% Y=repmat(Y',[300 1]);Y=Y(:);Y=Y';Y=single(Y);
% X=single(X);
% X=X';
% Y=Y';
% S=single(S);
% S=S';
% Y=Y';
% tic;[B FitInfo]=lassoglm(S,Y);toc;beep
% [b fitinfo] = lasso(S,Y,'CV',10)
load('lassofitElectrode.mat')
lassoPlot(b,fitinfo,'PlotType','Lambda','XScale','log');
load('Competition_train.mat')
X=permute(X,[2 3 1]);

S=zeros(64,300,278);
for t=1:278
    for c=1:64
        S(c,:,t)=decimate(X(c,:,t),10);
    end
end

S=permute(S,[1 3 2]);
S=single(reshape(S,[],300));

Y=repmat(Y',[64 1]);Y=Y(:);Y=Y';Y=single(Y);
tic;[B Fitinfo]=lassoglm(S,Y);toc;beep
lassoPlot(B,Fitinfo,'PlotType','Lambda','XScale','log');

for k=0:10:300
ii=1+ii;f(:,ii)=sum(S(:,k+1:k+10),2);end