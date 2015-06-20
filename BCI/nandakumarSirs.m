clc;clf;clear all;
x1=0.3*randn([1000,2])+1;m1=[0.5 0.1; 0.3 0.2]; x1n=x1*m1;
x2=0.5*randn([1000,2]);m2=[0.4 0.56; 0.56 0.82];x2=x2*m2;
y=[x1n;x2];
scatter(x1n(:,1),x1n(:,2),10,'b.'); hold on;
scatter(x2(:,1),x2(:,2),10,'r.'); hold on;
c1=x1n'*x1n;c1=c1/trace(c1);
c2=x2'*x2;c2=c2/trace(c2);
[u1,s1,v1]=svd(c1);s1
[u2,s2,v2]=svd(c2);s2
%line([0,u1(1,1)], [0,u1(2,1)]); hold on;
%line([0,u2(1,1)], [0,u2(2,1)]); 
c21=inv(c2)*c1;
[u3a,s3a,v3a]=svd(c21);
line([0,u3a(1,1)], [0,u3a(2,1)]); hold on;
line([0,v3a(1,1)], [0,v3a(2,1)]); hold on;

c12=inv(c1)*c2;
[u3b,s3b,v3b]=svd(c12);
line([0,u3b(1,1)], [0,u3b(2,1)]); hold on;
line([0,v3b(1,1)], [0,v3b(2,1)]); 

for i=1:1000

su1(i)= x1n(i,1)*u3a(1,1)+x1n(i,2)* u3a(2,1);
su4(i)= x1n(i,1)*v3b(1,1)+x1n(i,2)* v3b(2,1);
su3(i)= x1n(i,1)*u3b(1,1)+x1n(i,2)* u3b(2,1);
su2(i)= x1n(i,1)*v3a(1,1)+x1n(i,2)* v3a(2,1);
end;
suc1=[su1',su2',su3',su4'];
var1=var(suc1)

for i=1:1000

su1(i)= x2(i,1)*u3a(1,1)+x2(i,2)* u3a(2,1);
su4(i)= x2(i,1)*v3b(1,1)+x2(i,2)* v3b(2,1);
su3(i)= x2(i,1)*u3b(1,1)+x2(i,2)* u3b(2,1);
su2(i)= x2(i,1)*v3a(1,1)+x2(i,2)* v3a(2,1);
end;
suc2=[su1',su2',su3',su4'];
var2=var(suc2)
