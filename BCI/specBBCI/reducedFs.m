function[S]=reducedFs(X,L)
S=zeros(size(X,1),ceil(size(X,2)/L),size(X,3));
for t=1:size(X,3)
    for c=1:size(X,1)
        S(c,:,t)=decimate(X(c,:,t),L);
    end
end