clear all
close all
clc
 
%colormap(gray)

% create example image
 
ima=imread('testecg4.jpg');
ima1=rgb2gray(imread('testecg4.jpg'));
ima2=im2double(ima1); 
% add some noise
sigma=9;
rima1=im2uint8(sigma*randn(size(ima1)));
rima=ima1+rima1; 
% show it
figure;
%imshow(rima);

% denoise it
fima=NLmeansfilter(ima2,0,20,sigma);

% show results
figure;
imshow(ima1),title('original');
figure;
imshow(rima),title('noisy');
figure;
imshow(fima),title('filtered');
%figure;
%imshow(ima1+rima),title('residuals');


close all
figure

subplot(2,2,1),imshow(ima1),title('original');
subplot(2,2,2),imshow(rima),title('noisy');
subplot(2,2,3),imshow (fima),title('NLM filtered');
%subplot(2,2,4),imshow(fima+fima),title('final');
