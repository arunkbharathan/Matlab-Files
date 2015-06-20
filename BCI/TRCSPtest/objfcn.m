function [x] = objfcn(w)

global A B
x=((w*A*w')/(w*B*w'))+w*eye(3)*w';