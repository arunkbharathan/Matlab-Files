clc;clear;
load('Competition_train.mat')
S=sum(X((Y==1),:,:),1)/139;
S(2,:,:)=sum(X((Y==-1),:,:),1)/139;
X=0;
Y=[1;-1];

 Fs=1000;
 st=7;
 ed=30;
 stp=[st ed]/Fs;
 S=permute(S,[3 2 1]);

 S(:,:,1)= filtfilt(fir1(510,stp),1,S(:,:,1));
S(:,:,2)= filtfilt(fir1(510,stp),1,S(:,:,1));
S=permute(S,[2 1 3]);

AMean=mean(S,2);
AStd=std(S,0,2);

S = (S - repmat(AMean,[1 3000 1])) ./ repmat(AStd,[1 3000 1]);
Scell = num2cell(S,[1 2]);
Ep = cov(cat(2,Scell{:})');
reg.preproc = {Ep^-.5, Ep^-.5};
   [lhs rhs]=reg.preproc {:};
   X=cov(S(:,:,1)');
   X(:,:,2)=cov(S(:,:,2)');
    WC = zeros(size(X));
                    for t=1:size(X,3)
                        WC(:,:,t) = lhs*X(:,:,t)*rhs;
                    end
Xtmp=X;lmd=.2;                    
X=WC;
C = size(X,1); n = length(Y);
cvx_begin sdp
variable W(C,C) symmetric;
variable U(C,C) symmetric;
variable bias;
variable z(n);
minimize sum(log(1+exp(-z)))+lmd*trace(U);
subject to
for i=1:n
Y(i)*(trace(W*X(:,:,i))+bias)==z(i);
end
U >= W; U >= -W;
cvx_end
beep