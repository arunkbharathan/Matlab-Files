function Exw=buildEpochsofTrialsCov(C1,TperE)

k=1;
Exw=cell(1,ceil(size(C1,3)/TperE));
for i=1:TperE:size(C1,3)-rem(size(C1,3),TperE)
    seg=C1(:,:,i:i+TperE-1);
    sege = num2cell(seg,[1 2]);
    E = cov([sege{:}]');
    Exw{k}=E;
    k=k+1;
end
seg=C1(:,:,i+TperE:end);
if(size(seg,3)~=0)
sege = num2cell(seg,[1 2]);
 E = cov([sege{:}]');
    Exw{k}=E;
end
   
end