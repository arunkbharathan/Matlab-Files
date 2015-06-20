clear 
% clc
%Here m=7
m=7;
interference12=zeros(1,4);
e=[.2/5 .2/7 .2/8 .2/9 .02/9 .15/10];
d=([25/2 49/2 64/2 81/2 81/2 12/1]).^(-4);
 n= (8*randn(1,6))/10;
 n0=randn/10;
 r=(10.^(n))/(10^(n0));
 
%  interference11=zeros(1,6);interference=0;
%  
%     
%     interference11(1)=e(1)*d(1)*r(1);
%         
%     
% for m=2:6
%                 
%     interference=e(m)*d(m)*r(m);
%     interference11(m)=interference11(m-1)+interference;
% end
% 
% interference12(1)=interference11(1);
% interference12(2)=interference11(2);
% interference12(3)=interference11(4);
% interference12(4)=interference11(6);

sum(e.*d.*r)