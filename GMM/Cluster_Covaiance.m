%Co-variance Computation for a Cluster
function [COVAR] = Cluster_Covariance(Data)
[r,c] = size(Data);
for i=1:r
    COVAR(i) = var(Data(i,:));
end;
end;