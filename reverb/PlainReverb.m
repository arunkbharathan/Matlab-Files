function [out1] =  PlainReverb(data,delay,gain)
data=[data;zeros(44000,1)];
b=1;
z=zeros(1,delay);
a=[1 z -gain];
out1=filter(b,a,data);
end