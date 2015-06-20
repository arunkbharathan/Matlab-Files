% clc;clear;close all
% ima1=imread('pout.tif');
% ima2=im2double(ima1); 
% fs=fspecial('average');
% ima2=imfilter(ima2,fs,'symmetric');
% sigma=.1/3;
% rima=ima2+sigma*randn(size(ima1));
% 
% imshow(rima);
% j=parallel.cluster.Local
% j.NumWorkers=4
% matlabpool
% result=NLmeansfilter(rima,5,2,sigma);
% imshow(result);
%  matlabpool close
% beep
sigma=0.1;
t=1/8000:1/8000:2;
x=sin(2*pi*1000*t)+sigma*randn((size(t)));subplot(211)
% x=(ones(size(t)))+sigma*randn((size(t)));
plot(t,x)
y=NLmeansfilter(x,100,2,10*sigma);subplot(212)
plot(t,y)