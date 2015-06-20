clc;clear
load('matlab1.mat');
imshow(cir);
imshow(sqre);
imshow(cir+sqre)
Cx=cov(cir);imshow(10*Cx)
Cy=cov(sqre);imshow(10*Cy)
S=Cx+Cy;imshow(S)
[vec val]=eig(S);imshow(10*vec)
imshow(10*val)
p=pinv(sqrt(val))*vec';imshow(20*p)
SCcir=p*Cx*p';imshow(SCcir)
SCsqr=p*Cy*p';imshow(SCsqr)
[UCir sigmaCir]=eig(SCcir);

[sigmaCir,ind] = sort(diag(sigmaCir),'descend');
UCir = UCir(:,ind);sigmaCir=diag(sigmaCir);
[USqr sigmaSqr]=eig(SCsqr);
[sigmaSqr,ind] = sort(diag(sigmaSqr),'ascend');
USqr = USqr(:,ind);sigmaSqr=diag(sigmaSqr);
imshow(sigmaCir)
imshow(sigmaSqr)
imshow(20*USqr)
imshow(20*UCir)
U=USqr;scale=20;
W=(U'*p)';%coefficient of spatial filter
imshow(scale*W)
A=pinv(W);imshow(scale*A)
% W=(W'*p)';W=(W'*p)';W=(W'*p)';W=(W'*p)';

imshow(scale*cir*W)
imshow(scale*sqre*W)
imshow(scale*(sqre+cir)*W)
imshow(scale*cir*A)
imshow(scale*sqre*A)
imshow(scale*(sqre+cir)*A)
n=3;
Z=W(:,[1:n end-n+1:end]);
Z'*cir';
var(ans')
Z'*sqre';
var(ans')
