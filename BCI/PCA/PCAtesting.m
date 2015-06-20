%  A = [269.8 38.9 50.5
% 272.4 39.5 50.0
% 270.0 38.9 50.5
% 272.0 39.3 50.2
% 269.8 38.9 50.5
% 269.8 38.9 50.5
% 268.2 38.6 50.2
% 268.2 38.6 50.8
% 267.0 38.2 51.1
% 267.8 38.4 51.0
% 273.6 39.6 50.0
% 271.2 39.1 50.4
% 269.8 38.9 50.5
% 270.0 38.9 50.5
% 270.0 38.9 50.5
% ];
t=1/8000:1/8000:1;
s1=sin(2*pi*2*t);s2=sin(2*pi*4*t);s3=sin(2*pi*6*t);A=[s1; s2; s3]';
B=A;
% [n m] = size(A)
% AMean = mean(A)
% AStd = std(A)
% B = (A - repmat(AMean,[n 1])) ./ repmat(AStd,[n 1])
[V D] = eig(cov(B))
[COEFF SCORE LATENT] = princomp(B);
AAA=B * COEFF;
 (B * COEFF) * COEFF';
%   ((B * COEFF) * COEFF') .* repmat(AStd,[n 1]) + repmat(AMean,[n 1])
  cumsum(var(SCORE)) / sum(var(SCORE))
  SCOREvar=var(B * COEFF);
  cumsum(SCOREvar) / sum(SCOREvar)