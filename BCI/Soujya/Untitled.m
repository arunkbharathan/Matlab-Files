
 load('C:\Users\ArunKB\Documents\MATLAB\BCI\specBBCI\FIL5_35Competition_train.mat')
% 
%  
%  AMean=mean(S,2);
%  AStd=std(S,0,2);
%  S = (S - repmat(AMean,[1 3000 1])) ./ repmat(AStd,[1 3000 1]);
  patterns=1;i=1;filters=0;
[filters,features] = CSPBCI(S,Y,patterns,filters,i);
%  
% 
  w=filters(:);
 
 
 tic;[abc,fval]=untitled8(w,1e10,1e10);toc
 abcc=[abc(1:64) abc(65:128) ];%abc(129:192) abc(193:256) abc(257:320) abc(321:384)];
 beep;filters=abcc;fval
 SouFeatureExtrat