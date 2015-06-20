function PredictedClass=computeOP(voted,data)
classProb = zeros(length(data),4);
ssd=@(x) 1./(1+exp(-x));
for i=1:4
    for j=i+1:4

      W=voted{i,j};
      L = [ones(length(data),1) data] * W';
      P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
      outclass=double(P(:,1)>P(:,2));

      for tmp=1:length(data)
           
       switch(outclass(tmp))
           case 1
              classProb(tmp,i) = P(tmp,1)+classProb(tmp,i);
              classProb(tmp,j) = P(tmp,2)+classProb(tmp,j);
           case 0
               classProb(tmp,j) = P(tmp,2)+classProb(tmp,j);
              classProb(tmp,i) = P(tmp,1)+classProb(tmp,i);
       end
      end
    end
end
    classProb = classProb ./ repmat(sum(classProb,2),[1 4]);
[ProbVal index]=max(classProb,[],2);
PredictedClass=index; 
end