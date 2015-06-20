k=combntns(1:18,2);opo=[];
for i=1:length(k)
qqq=c(k(i,1),:)+c(k(i,2),:);
parfor j=1:278
temp(:,:,j)= filtfilt(qqq,1,X(:,:,j));
end
t=ipermute(temp,[2 1 3]);
[a b]=First_BCI(t,Y);
me=(mean(a)+mean(b))/2;
d=me;
opo=[opo;k(i,1) k(i,2) (sum((b>d))+sum((a<d)))/(length(b)+length(a))*100]
% wraa{i}=find(a<d);
% wrbb{i}=find(b>d);
% plot(a,'.');hold
% plot(b,'.r');hold off
% line([0 140],[d d],'Marker','.','LineStyle','-','color','b')

beep;
end
