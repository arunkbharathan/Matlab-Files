m1=[0 0];m=[0 0];m2=[3 0];
p1=mvnrnd(m1,[2.929 2.9212;2.9212 2.9290],1000);
p2=rand(1000,2);
% p1=p1';p2=p2';
%  AMean=mean(p1,2);
%  AStd=std(p1,0,2);
%  p1 = (p1 - repmat(AMean,[1 length(p1) 1])) ./ repmat(AStd,[1 length(p1) 1]);
%  AMean=mean(p2,2);
%  AStd=std(p2,0,2);
%  p2 = (p2 - repmat(AMean,[1 length(p1) 1])) ./ repmat(AStd,[1 length(p1) 1]);p1=p1';p2=p2';
   c1=p1;
c2=p2;figure
scatter(p1(:,1),p1(:,2),30,'b.'); hold on;
scatter(p2(:,1),p2(:,2),30,'r.'); hold
P1=cov(p1);
P2=cov(p2);
[a b]=eig(P1)
[a b]=eig(P2)
c1=p1*P1;c2=p2*P2;figure
scatter(c1(:,1),c1(:,2),30,'b.'); hold on;
scatter(c2(:,1),c2(:,2),30,'r.'); hold
[vec val]=eig(P1+P2)
p=pinv(sqrt(val))*vec'
SCf=p*P1*p'
SCh=p*P2*p'
[U1 sigmaF]=eig(SCf)
[U2 sigmaH]=eig(SCh)
c1=p1*SCf;c2=p2*SCh;figure
scatter(c1(:,1),c1(:,2),30,'b.'); hold on;
scatter(c2(:,1),c2(:,2),30,'r.'); hold
U=U1;
c1=p1*U;c2=p2*U;figure
scatter(c1(:,1),c1(:,2),30,'b.'); hold on;
scatter(c2(:,1),c2(:,2),30,'r.'); hold
sigmaF+sigmaH
W=p'*U;
c1=p1*W;c2=p2*W;figure
scatter(c1(:,1),c1(:,2),30,'b.'); hold on;
scatter(c2(:,1),c2(:,2),30,'r.'); hold

[v d]=eig(P1,P1+P2)
c1=p1*v;c2=p2*v;figure
scatter(c1(:,1),c1(:,2),30,'b.'); hold on;
scatter(c2(:,1),c2(:,2),30,'r.'); hold