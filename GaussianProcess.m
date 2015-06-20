% clear
kernel =2;
%  j=parallel.cluster.Local
%  j.NumWorkers=4
%  matlabpool
switch kernel
    case 1; k=@(x,y) 1*x'*y;
    case 2; k=@(x,y) 1*min(x,y);
    case 3; k=@(x,y) exp(-100*(x-y)'*(x-y));
    case 4; k=@(x,y) exp(-1*sqrt((x-y)'*(x-y)));
    case 5; k=@(x,y) exp(-1*sin(5*pi*(x-y))^2);
    case 6; k=@(x,y) exp(-100*min(abs(x-y),abs(x+y)));    
end

x=-1:0.005:1;
n=length(x);

C=zeros(n,n);
parfor i=1:n
    for j=1:n
        
        C(i,j)=k(x(i),x(j));
    end
end

u=randn(n,1);
[A S B]=svd(C);
z=A*sqrt(S)*u;

figure(2);%hold on;%clf
plot(x,z,'.-')
% axis([0,1,-2,2])