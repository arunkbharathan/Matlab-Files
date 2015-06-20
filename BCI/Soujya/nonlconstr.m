function [c,ceq] = nonlconstr(w)
% E =[1.1200   -0.0079   -0.0631;...
%    -0.0079    1.0916   -0.0232;...
%    -0.0631   -0.0232    1.0927];
% w1=w(1:3);w2=w(4:6);
w1=w(1:118);w2=w(119:236);global Csum;
 w3=w(237:354);w4=w(355:472);
% w5=w(257:320);w6=w(321:384);
W=[w1 w2 w3 w4];% w5 w6];
c = [];
q = [w1'*Csum*w1-1;
       w2'*Csum*w2-1;
        w3'*Csum*w3-1;
        w4'*Csum*w4-1];
%        w5'*Csum*w5-1;
%        w6'*Csum*w6-1];
   k=zeros(1,6);t=1;
   for i=1:4
       for j=i+1:4
          k(t)= W(:,i)'*Csum*W(:,j);
          t=t+1;
       end
   end
   ceq=[q;k'];
end
           