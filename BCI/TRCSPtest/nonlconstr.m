function [c,ceq] = nonlconstr(w)
global B
c = [];
ceq = (w*B*w'+w*eye(10)*w')-1;
end
           