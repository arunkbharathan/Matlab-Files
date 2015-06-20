function [x] = origTRCSP(w)

global A B
x=(w*A*w')/(w*B*w'+w*eye(10)*w');