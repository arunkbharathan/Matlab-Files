function[filters features patterns] = CSPBCI(X,Y,patterns,filters,i)
if i
    classes=unique(Y);
    C1=X(:,:,Y==classes(1));
    C2=X(:,:,Y==classes(2));
    covar1= cov(reshape(C1,size(C1,1),[])');
    covar2= cov(reshape(C2,size(C2,1),[])');

      [W,D] = eig(covar1,covar1+covar2); 
            filters = W(:,[1:patterns end-patterns+1:end]);
            P = inv(W);
            patterns = P([1:patterns end-patterns+1:end],:);
            
end
features = zeros(size(X,3),size(filters,2));
            for t=1:size(X,3)
                features(t,:) = log(var(X(:,:,t)'*filters)); 
            end
end