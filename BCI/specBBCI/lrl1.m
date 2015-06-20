function [W, bias, z]=lrl1(X, Y, lmd)
C = size(X,1); n = length(Y);
cvx_begin sdp
variable W(C,C) symmetric;
variable U(C,C) symmetric;
variable bias;
variable z(n);
minimize sum(log(1+exp(-z)))+lmd*trace(U);
subject to
for i=1:n
Y(i)*(trace(W*X(:,:,i))+bias)==z(i);
end
U >= W; U >= -W;
cvx_end
end