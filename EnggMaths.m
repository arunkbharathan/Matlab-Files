ezplot3('cos(4*t)','sin(32*t)','t',[0,6*pi])
ezplot3('cos(t)','2*sin(t)','t',[0,2*pi])
ezplot3('cos(t-pi/4)','2*sin(t-pi/4)','t',[0,2*pi])
ezplot3('cos(t)','sin(t)','t',[0,2*pi],'animate')
ezplot3('cos(-t)','sin(t)','t',[0,2*pi],'animate')
ezplot3('t*log(abs(t))','exp(t)','(1+t)^(-1)',[0,2*pi],'animate')
ezplot3('t*log(t)','exp(t)','(1+t)^(-1)',[-100,100],'animate')
ezplot3('3*cos(t)','3*sin(t)','4*t',[0,2*pi],'animate')
ezplot3('-sin(t)','sin(-t)','t',[0,2*pi],'animate')
ezplot3('sqrt(-2*sin(t)+3*cos(t))','0',[0,2*pi],'animate')
ezplot3('sqrt(-2*sin(t)+3*cos(t))','t','t',[0,2*pi],'animate')
syms t
x = t*sin(5*t);
y = t*cos(5*t);
ezplot(x, y)
syms x y
f(x, y) = sin(x + y)*sin(x*y);
ezplot(f)
sinh(2)
[x,y] = meshgrid(0:0.2:2,0:0.2:2);
u = cos(x).*y;
v = sin(x).*y;
figure
quiver(x,y,u,v)
h=ezplot('exp(-x)+exp(-2*x)',[1 0],[0 20]);set(h,'Color','k')
h=ezplot('1-x^2',[0 20 0 2]);set(h,'Color','r');
h=ezplot('1-cos(t-1)',[1 3 -1 1])
symsum(x^n/sym('n!'), n, 0, Inf)
symsum((-6/(n*pi))*(((-1)^n)-1)*sin(n*pi*x), n, 1, 40)
h=ezplot(ans,[1 10])
(power(-1,k-1))/(power(2*k-1,2))*sin(2*k*x-x)*cos(6*k*t-3*t)
f(x,t)=4/pi*symsum(-((-1)^(k - 1)*sin(x - 2*k*x)*cos(3*t - 6*k*t))/(2*k - 1)^2, k, 1, 20)
ezplot(f)
ezplot(f,[-2 2 -2 2])
