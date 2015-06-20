function [k]  = plotit(aa,p1,c)
y=(aa*p1')';
plot(y(:,1),y(:,2),c)
k=[];
end