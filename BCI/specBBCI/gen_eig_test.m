a=randn(1000,3)';b=0.5*randn(1000,3)';
 AMean=mean(a,2);
 AStd=std(a,0,2);
 a = (a - repmat(AMean,[1 1000 1])) ./ repmat(AStd,[1 1000 1]);
 AMean=mean(b,2);
 AStd=std(b,0,2);
 b = (b - repmat(AMean,[1 1000 1])) ./ repmat(AStd,[1 1000 1]);a=a';b=b';
scatter(a(:,1),a(:,2),10,'b.'); hold on;
scatter(b(:,1),b(:,2),10,'r.'); hold
c1=cov(a)
c2=cov(b)
plot_ellipse(c1);hold;plot_ellipse(c2,'r')
[v d]=eig(c1,c2)
v(:,1)'*c1*v(:,1)
var(v(:,1)'*a')
v(:,1)'*c2*v(:,1)
var(v(:,1)'*b')
v(:,end)'*c1*v(:,end)
var(v(:,2)'*a')
v(:,2)'*c2*v(:,end)
var(v(:,end)'*b')
v(:,[1 end])'*c1*v(:,[1 end])
v(:,[1 end])'*c2*v(:,[1 end])
[v d]=eig(c1,c2+c1)
v(:,1)'*c1*v(:,1)
var(v(:,1)'*a')
v(:,1)'*c2*v(:,1)
var(v(:,1)'*b')
v(:,end)'*c1*v(:,end)
var(v(:,end)'*a')
v(:,end)'*c2*v(:,end)
var(v(:,end)'*b')
v(:,[1 end])'*c1*v(:,[1 end])
v(:,[1 end])'*c2*v(:,[1 end])