function [out]= AllPassReverb(data,delay,gain)
data=[data;zeros(44000,1)];
z=zeros(1,delay-1);
b=[-gain z 1];
a=[1 z -gain];
out=filter(b,a,data);
end