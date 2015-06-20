 load('FIL5_35Competition_train100.mat');%S=shiftdim(X,1);clear X;
%  L=10;
%  S=reducedFs(S,L);
%  Fs=100;
 Scell = num2cell(S,[1 2]);
 Ep = cov(cat(2,Scell{:})');
 reg.preproc = {Ep^-.5, Ep^-.5};
 [lhs, rhs]=reg.preproc {:};
   
    WC = zeros(size(S,1),size(S,1),size(S,3));
                    for t=1:size(S,3)
                        WC(:,:,t) = lhs*cov(S(:,:,t)')*rhs;
                    end
                bs=  1/sqrt(sum(sum(var(WC,[],3)))); reg.preproc{3}=bs;
                 for t=1:size(S,3)
                        WC(:,:,t) = bs*lhs*cov(S(:,:,t)')*rhs;
                 end
               
               
                 resultY=zeros(size(Y));
                 for t=1:size(S,3)
                 ICC=WC(:,:,t);
                 resultY(t)=sum(ICC(:).*W(:))+bias;
                 end
                 sum(sign(resultY)==Y)/length(Y)*100
               