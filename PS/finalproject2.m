clear all
close all
clc
 
% Enter image
ima=imread('testecg4.jpg');
ima1=rgb2gray(imread('testecg4.jpg'));
ima2=im2double(ima1); 
%imhist(ima1),title('original');
%ff0=fft2(ima1);
%imshow(ff0),title('fft of orginal');

% Add noise
sigma=9;
rima1=im2uint8(sigma*randn(size(ima1)));
rima=ima1+rima1; 
%figure;
%imhist(rima),title('noisy');
%ff1=fft2(rima);
%figure;
%imshow(ff1),title('fft of noisy');
% show it
%figure;
%imshow(rima);

% denoise it
fima=NLmeansfilter(ima2,0,20,sigma);
%imhist(fima),title('filtered');
%ff2=fft2(fima);
%figure;
%imshow(ff2),title('fft of filtered');
% show results
%figure;
%close all
figure
imhist(rima);
subplot(2,2,1),imhist(ima1),title('original');
subplot(2,2,2),imhist(rima),title('noisy');
subplot(2,2,3),imhist (fima),title('NLM filtered');
figure;
subplot(2,2,1),imshow(ima1),title('original');
subplot(2,2,2),imshow(rima),title('noisy');
subplot(2,2,4),imshow (fima),title('NLM filtered');
%subplot(2,2,4),imshow(fima+fima),title('final');

