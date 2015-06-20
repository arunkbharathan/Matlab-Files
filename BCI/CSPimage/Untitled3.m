clc;clear
load('matlab2.mat');
imagesc(cir);
imagesc(sqre);
imagesc(cir+sqre)
Cx=cov(cir);imagesc(10*Cx)
Cy=cov(sqre);imagesc(10*Cy)
S=Cx+Cy;imagesc(S)
[vec val]=eig(S);imagesc(10*vec)
imagesc(10*val)
p=pinv(sqrt(val))*vec';imagesc(20*p)
SCcir=p*Cx*p';imagesc(SCcir)
SCsqr=p*Cy*p';imagesc(SCsqr)
[UCir sigmaCir]=eig(SCcir);

[sigmaCir,ind] = sort(diag(sigmaCir),'descend');
UCir = UCir(:,ind);sigmaCir=diag(sigmaCir);
[USqr sigmaSqr]=eig(SCsqr);
[sigmaSqr,ind] = sort(diag(sigmaSqr),'ascend');
USqr = USqr(:,ind);sigmaSqr=diag(sigmaSqr);
imagesc(sigmaCir)
imagesc(sigmaSqr)
imagesc(20*USqr)
imagesc(20*UCir)
U=UCir;scale=20;
W=(U'*p)';%coefficient of spatial filter
imagesc(scale*W)
A=pinv(W);imagesc(scale*A)
% W=(W'*p)';W=(W'*p)';W=(W'*p)';W=(W'*p)';

imagesc(scale*cir*W)
imagesc(scale*sqre*W)
imagesc(scale*(sqre+cir)*W)
imagesc(scale*cir*A)
imagesc(scale*sqre*A)
imagesc(scale*(sqre+cir)*A)
n=3;
Z=W(:,[1:n end-n+1:end]);
Z'*cir';
var(ans')
Z'*sqre';
var(ans')

t=ones(size(cir));
imshow(t*W)
imshow(t*A)
