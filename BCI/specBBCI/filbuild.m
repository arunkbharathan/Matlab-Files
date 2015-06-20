clc;clear all;close all
Fs=1000;c=zeros(18,511);
st=4;
ed=40;
stp=(st:2:ed)/Fs;
for i=1:(length(stp)-1)
c(i,:) = fir1(510,[stp(i) stp(i+1)]);
end
load('Competition_train.mat')
X=permute(X,[2 3 1]);
[a b]=First_BCI(X,Y);
X=ipermute(X,[2 3 1]);
md=(median(a)+median(b))/2;
me=(mean(a)+mean(b))/2;
d=me;
plot(a,'.');hold
plot(b,'.r');hold off
line([0 140],[d d],'Marker','.','LineStyle','-','color','b')
sum((a<d))/length(a)*100
sum((b>d))/length(b)*100
(sum((b>d))+sum((a<d)))/(length(b)+length(a))*100
find(a<d) 
find(b>d)
X=permute(X,[3 2 1]);
temp=zeros(size(X));ioi=zeros(18,4);
multiWaitbar('CLOSEALL');
 multiWaitbar( 'Computing', 0.5, 'Color', 'r' );
 m=size(c,1);
for i=1: m
%     [stp(i) stp(i+1)]*Fs
qqq=c(i,:);
parfor j=1:278
   temp(:,:,j)= filtfilt(qqq,1,X(:,:,j));
end
t=ipermute(temp,[2 1 3]);
[a b]=First_BCI(t,Y);
% md=(median(a)+median(b))/2;
me=(mean(a)+mean(b))/2;
d=me;
% plot(a,'.');hold
% plot(b,'.r');hold off
% line([0 140],[d d],'Marker','.','LineStyle','-','color','b')
% sum((a<d))/length(a)*100;
% sum((b>d))/length(b)*100;
wronga{i}= find(a<d); 
wrongb{i}= find(b>d);
% [[stp(i) stp(i+1)]*Fs (sum((b>d))+sum((a<d)))/(length(b)+length(a))*100]
ioi(i,:)=[i [stp(i) stp(i+1)]*Fs (sum((b>d))+sum((a<d)))/(length(b)+length(a))*100]
beep;
multiWaitbar( 'Computing', i/m );
end
beep;beep;beep;multiWaitbar('CLOSEALL');