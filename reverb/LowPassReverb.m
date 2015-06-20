function [result] = LowPassReverb(data,delay,a1,b0,b1)
data=[data;zeros(44000,1)];
z= zeros(1,delay-1);
num= [1 a1];
den= [1 a1 z -b0 -b1];
result = filter (num,den,data);
end