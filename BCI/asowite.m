function [Wf Wh]=asowite(p1,p2)
C1=cov(p1');
C2=cov(p2');
[vec1 val1]=eig(C1,C1+C2);
[val1,ind] = sort(diag(val1),'descend');
vec1 = vec1(:,ind); val1=diag(val1);
[vec2 val2]=eig(C2,C1+C2);
[val2,ind] = sort(diag(val2),'descend');
vec2= vec2(:,ind);val2=diag(val2);
pp1=pinv(sqrt(val1))*vec1';
pp2=pinv(sqrt(val2))*vec2';
SCh=pp2*C2*pp2';
SCf=pp1*C1*pp1';
[U1 sigmaH]=eig(SCh);
[U2 sigmaF]=eig(SCf);
%[sigmaH,ind1] = sort(diag(sigmaH),'ascend');
%%[sigmaF,ind2] = sort(diag(sigmaF),'ascend');
U1 = U1(:,ind);sigmaH=diag(sigmaH);
U2 = U2(:,ind);sigmaF=diag(sigmaF);
Uh=U1;
Wh=(Uh'*pp1)';%imagesc(inv(W));


Uf=U2;
Wf=(Uf'*pp2)';%imagesc(inv(W));
