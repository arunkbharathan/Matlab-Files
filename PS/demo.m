clear
clc
clf
colormap(gray)

% create example image
ima=ecg(1000);
ima=repmat(ima,8,2);
% fs=fspecial('average');
% ima=imfilter(ima,fs,'symmetric');

% add some noise
sigma=0.1;
rima=ima+sigma*randn(size(ima));

% show it
imagesc(rima)
drawnow

% denoise it
fima=NLmeansfilter(rima,8,2,.71);
fima=NLmeansfilter(fima,8,2,.71);beep
plot(fima(1,1:1000))
% show results
clf
subplot(2,2,1),imagesc(ima),title('original');
subplot(2,2,2),imagesc(rima),title('noisy');
subplot(2,2,3),imagesc(fima),title('filtered');
subplot(2,2,4),imagesc(rima-fima),title('residuals');

