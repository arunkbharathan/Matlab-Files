clc;clear 
load('Competition_train.mat');
[W,training]=I_BCI(X,Y);
load('Competition_test.mat');
X=shiftdim(X,1);%(No: electrodes,samples,trials)
sample=[];
for i=1:size(X,3)   
       C2= W'*X(:,:,i);
   C2=var(C2,0,2)';
 t=sum(C2);
 C2=log(C2/t);
 sample=[sample; C2];
end

group=[ones(139,1) ;-1*ones(139,1)];
[ldaClass,err,P,logp,coeff] = classify(sample,training,group,'quadratic');
% [ldaResubCM,grpOrder] = confusionmat(sample,ldaClass);
 h1=gscatter(P(:,2),ldaClass);
(sum(ldaClass(1:139)==-1)+sum(ldaClass(140:278)==1))/278*100
sum(ldaClass~=Y)/278*100
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x,y) K + [x y]*L;
h2 = ezplot(f,[min(All_data(:,1)) max(All_data(:,1)) min(All_data(:,2)) max(All_data(:,2))]);
hold on