%Reimann Distance
ReimanDist=@(C,K) sqrt(sum(log(eig(C^-.5*K*C^-.5)).^2));

load('FIL5_35Competition_train100.mat');
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
tra(t) = norm(eig(bs*lhs*cov(S(:,:,t)'*rhs)));
end
plot(tra,'r');hold
load('FIL5_35Competition_test100.mat');

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
tes(t) = norm(eig(bs*lhs*cov(S(:,:,t)'*rhs)));
end
plot(tes)