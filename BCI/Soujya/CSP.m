%   CSP Function

%   Coded by James Ethridge and William Weaver

function [filters] = CSP(X,Y,patterns)
    

    
    
    Rsum=0;
    %finding the covariance of each class and composite covariance
    classes=unique(Y);
    C1=X(:,:,Y==classes(1));
    C2=X(:,:,Y==classes(2));
    covar1= cov(reshape(C1,size(C1,1),[])');
    covar2= cov(reshape(C2,size(C2,1),[])');

    
 
        R{1} = covar1;R{2}=covar2;
        Rsum=R{2}+R{1};
   
    
    
   
    %   Find Eigenvalues and Eigenvectors of RC
    %   Sort eigenvalues in descending order
    [EVecsum,EValsum] = eig(Rsum);
    [EValsum,ind] = sort(diag(EValsum),'descend');
    EVecsum = EVecsum(:,ind);
    
    %   Find Whitening Transformation Matrix - Ramoser Equation (3)
        W = sqrt(inv(diag(EValsum))) * EVecsum';
    
    
    for k = 1:2
        S{k} = W * R{k} * W'; %       Whiten Data Using Whiting Transform - Ramoser Equation (4)
    end
    
    
    
    % Ramoser equation (5)
   % [U{1},Psi{1}] = eig(S{1});
   % [U{2},Psi{2}] = eig(S{2});
    
    %generalized eigenvectors/values
    [B,D] = eig(S{1},S{2});
    % Simultanous diagonalization
			% Should be equivalent to [B,D]=eig(S{1});
    
    %verify algorithim
    %disp('test1:Psi{1}+Psi{2}=I')
    %Psi{1}+Psi{2}
    
    %sort ascending by default
    %[Psi{1},ind] = sort(diag(Psi{1})); U{1} = U{1}(:,ind);
    %[Psi{2},ind] = sort(diag(Psi{2})); U{2} = U{2}(:,ind);
    [D,ind]=sort(diag(D));B=B(:,ind);
    
    %Resulting Projection Matrix-these are the spatial filter coefficients
    filters = B(:,[1:patterns end-patterns+1:end])'*W;
    filters=filters';
    %(:,[1:patterns end-patterns+1:end])
end
