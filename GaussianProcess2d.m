clear
kernel =3;
%  j=parallel.cluster.Local
%  j.NumWorkers=4
%  matlabpool
switch kernel
    case 1; k=@(x,y) 1*x'*y;
    case 2; k=@(x,y) exp(-100*(x-y)'*(x-y));
    case 3; k=@(x,y) exp(-1*sqrt((x-y)'*(x-y)));
       
end

points=(0:0.05:1)';
[U V]=meshgrid(points,points);
x=[U(:) V(:)]';
n=size(x,2);

C=zeros(n,n);
for i=1:n
    for j=1:n
          C(i,j)=k(x(:,i),x(:,j));
    end
end

u=randn(n,1);
[A S B]=svd(C);
z=A*sqrt(S)*u;

figure(2);clf;%hold on;
Z=reshape(z,sqrt(n),sqrt(n));
surf(U,V,Z)
% axis([0,1,-2,2])