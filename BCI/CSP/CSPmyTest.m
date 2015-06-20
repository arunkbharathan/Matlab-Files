t=1/8000:1/8000:1;
s3=sin(2*pi*11*t);
s2=sin(2*pi*3*t);
s22=sin(2*pi*6*t);
s1=sin(2*pi*250*t);
s11=sin(2*pi*15*t);
Xf=[s2; s3 ;s22];
Xh=[s2;s3;s11];
Cf=Xf*Xf'/trace(Xf*Xf')
Ch=Xh*Xh'/trace(Xh*Xh')
Csum=Cf+Ch
[Uo sigma]=eig(Csum)
P=pinv(sqrt(sigma))*Uo'
SCf=P*Cf*P'
SCh=P*Ch*P'
[U1 sigmaF]=eig(SCf)
[U2 sigmaH]=eig(SCh)

U=U1;
[U sigmaFH]=eig(SCf,SCh)
sigmaF+sigmaH
W=P'*U;%coefficient of spatial filter
A=pinv(W);
Zf=W*Xf;
Zh=W*Xh;