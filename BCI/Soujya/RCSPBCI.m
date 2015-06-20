function[filters features patterns] = CSPBCI(X,Y,patterns,filters,i)
if i
    classes=unique(Y);
    C1=X(:,:,Y==classes(1));
    C2=X(:,:,Y==classes(2));
    covar1= cov(reshape(C1,size(C1,1),[])');
    covar2= cov(reshape(C2,size(C2,1),[])');

M1=(covar2+0.4*eye(size(covar1)))\covar1;
M2=(covar1+0.4*eye(size(covar1)))\covar2;
[W1,D1]=eig(M1);
[W2,D2]=eig(M2);
P1 = inv(W1);
P2 = inv(W2);
            filters = [P2(1:patterns,:); P1(patterns:-1:1,:)]';
            patterns = [W2(:,1:patterns) W1(:,patterns:-1:1)]';
            
end
features = zeros(size(X,3),size(filters,2));
            for t=1:size(X,3)
                features(t,:) = log(var(X(:,:,t)'*filters)); 
            end
end