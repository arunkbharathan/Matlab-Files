feature=[];
for k=1:length(Y)
    
        E=X(:,:,k);
 
 Z=W'*E;
 Z=var(Z');
 t=sum(Z);
 Z=log(Z/t);
 feature=[feature; Z];
end


% for i=3:3
%  FH{i} =  log(var((SFf{i}*Z)'));
%  FF{i} =  log(var((SFh{i}*Z)'));
%  end
%  S{k}={FH FF};
%  featureH=[featureH;S{1}{1}{3}];
%  featureF=[featureF;S{1}{2}{3}];