function [result kk]=kmeansquant(training,nc,C)
r=[];np=length(training);dim=3;
r=randperm(np,nc);
% P=round(rand(np,dim)*1000);%dimension 3
% P=[1 1 0;2 1 0;4 3 0;5 4 0];r=[1 2]
P=training;
Dd=[];D=[];p=repmat(P,1,nc);prevG=zeros(np,1);
C=P(r,:);
for kk=1:20000
c=C.';c=c(:).';

     c=repmat(c,np,1);
     
     l=(c-p).^2;
     for i=1:3:nc*3
     Dd=[Dd;l(:,i:i+2)];
     end
     D=Dd;Dd=[];
D=sqrt(sum(D.').');
D=reshape(D,np,nc);

    [m G]=min(D,[],2);
    X=P(:,1);Y=P(:,2);Z=P(:,3);
    for i=1:nc
        if(sum((G==i))~=0);
            x=X(G==i);y=Y(G==i);z=Z(G==i);
        C(i,:)=[sum(x) sum(y) sum(z)]./sum((G==i));
        end
        
    end
    if(prevG==G)
        break;
    end
    prevG=G;
end
result=C;
end