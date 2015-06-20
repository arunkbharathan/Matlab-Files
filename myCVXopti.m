m = 16; n = 8;
A = dct(eye(256));
b = sin(2*pi*10*linspace(0,1,256));
cvx_begin
variable x(256)
minimize( norm(A*x-b') )
subject to
x>.2
cvx_end
plot(b)
hold
plot(x)