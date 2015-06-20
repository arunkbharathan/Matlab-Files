function [x] = objfcn2(w)
% w1=w(1:3);w2=w(4:6);
% E1=[1.0346   -0.0044   -0.0589;...
%    -0.0044    1.0075   -0.0194;...
%    -0.0589   -0.0194    1.0102];
% 
% E2 =  [0.0854   -0.0035   -0.0042;...
%    -0.0035    0.0841   -0.0038;...
%    -0.0042   -0.0038    0.0825];
w1=w(1:118);w2=w(119:236);global Cf Ch Ew1 Ew2
 w3=w(237:354);w4=w(355:472);
% w5=w(257:320);w6=w(321:384);
 x=w1'*Ch*w1+w4'*Cf*w4+w2'*Ch*w2+w3'*Cf*w3;
%    w2'*Ch*w2+w5'*Cf*w5+...
%     w3'*Ch*w3+w6'*Cf*w6;
% x=w1'*Ch*w1+w2'*Cf*w2;
     w=[w1 w2 w3 w4]';% w5 w6]';
%  %KLdiv=@(E0,E1) 0.5*(trace(E1\E0)-log(det(E0)/det(E1))-length(E1));
% 
tot1=zeros(size(Ew1,3),1);tot2=zeros(size(Ew2,3),1);
cff=w*Cf*w.';
chh=w*Ch*w.';
       for t=1: size(Ew1,3)
         tot1(t)=  sqrt(sum(log(eig((w*Ew1(:,:,t)*w.')^-.5*cff*(w*Ew1(:,:,t)*w.')^-.5)).^2));
       end
       for t=1: size(Ew2,3)
         tot2(t)=  sqrt(sum(log(eig((w*Ew2(:,:,t)*w.')^-.5*chh*(w*Ew2(:,:,t)*w.')^-.5)).^2));
       end
       L=0.5*sum(([tot1;0;0]/size(Ew1,3)+tot2/size(Ew2,3)));
       
       x=.5*x+.5*L;

end