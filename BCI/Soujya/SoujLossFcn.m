function [L]=SoujLossFcn(w,E1T,E2T,Ew1,Ew2)

KLdiv=@(E0,E1) 0.5*(trace(E1\E0)-log(det(E0)/det(E1))-length(E1));
%   L=zeros(size(W,1),1); 
%   for i=1:size(W,1)
%        w=W(i,:);
tot1=zeros(length(Ew1),1);tot2=zeros(length(Ew2),1);
       for t=1: length(Ew1)
         tot1(t)=  KLdiv(w*Ew1{t}*w.',w*E1T*w.');
       end
       for t=1: length(Ew2)
         tot2(t)=  KLdiv(w*Ew2{t}*w.',w*E2T*w.');
       end
       L=0.5*sum((tot1/length(Ew1)+tot2/length(Ew2)));
%   end
end
            