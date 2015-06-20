np=60*60;nc=30;%num_of_pts and num_of_centroids
P=round(rand(np,3)*1000);%P is a matrix of dim (num_pts) x 3 since 3 dimension

[result kk]=kmeansquant(P,nc,[]);%pass the trainig vector of arrays in P and num 
%of centroid(reconstruction level) needed.

%result is an array of dim(num_centroid x 3) where 3 is X Y Z

% if we want to find to many centroids and np is big(eg: np=10000 and nc=300) 
%the algorithm may not find optimum points(in that case kk=20000) in first pass 
%then execute again with result=kmeansquant(P,nc,Prev_result)

%now we want to quantize [300 200 155];  find distance to each centroids
%and choose the vector with minimum distance 
vec_point=[300 200 155];
for i=1:length(result)
    d(i)=norm(vec_point-result(i,:));%finding eucledian dist or l2 norm between points
end
[minvalue index]=min(d);
index
d(index)%is min distance reconstruction level or centroid

% we will send the index of min value centroid,  receiver will have same
% reconstruction levels(centroids) in same order there in look up table
% manner it will output the centroid(index);


%go to link below for algorithm
% http://people.revoledu.com/kardi/tutorial/kMean/NumericalExample.htm



