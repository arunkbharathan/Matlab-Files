load('FIL5_35Competition_test.mat');
signal.data=S;signal.label=[];
features = zeros(size(signal.data,3),size(model.W,2));
            for t=1:size(signal.data,3)
                features(t,:) = log(var(2*real(ifft(model.alpha.*fft(signal.data(:,:,t)'*model.W))))); end         
         
            L = [ones(size(features,1),1) features] * TC';
%             Prob = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
revind=@(c) (2*c-3);
[a b]=max(L,[],2)
a=revind(b);
load('trueLabel.mat')
sum(trueLabel==a)