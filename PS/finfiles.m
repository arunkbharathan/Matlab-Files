% create example image
clear all
ima=50*ones(1,1000);
ima(500:1000)=100;
ima=[ima ima ima ima];
%%We can make use of multiple cores of cpu to speed up processing.
%%Uncomment below 3 commented lines(Now the multi waitbar is not correct. )
    % j=parallel.cluster.Local
    % j.NumWorkers=4  % give the number of cores of cpu here
    % matlabpool
    
% add some noise
sigma=10;
rima=ima+sigma*randn(size(ima));
plot(rima);title('noisy')
k=[];
for i=1:100
fima=NLmeansfilter(rima,5,2,i);
k=[k ;var(fima-ima)]
end
plot(fima);title('filtered')


    %  matlabpool %closes the parallel workers