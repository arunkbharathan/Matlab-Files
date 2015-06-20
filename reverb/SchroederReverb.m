function [output]=SchroederReverb(data,D1,D2,D3,D4,D5,D6,a1,a2,a3,a4,a5,a6,b1,b2,b3,b4)
data=[data;zeros(44000,1)];
result=b1*PlainReverb(data,D1,a1)+b2*PlainReverb(data,D2,a2)+b3*PlainReverb(data,D3,a3)...
    +b4*PlainReverb(data,D4,a4);
result=AllPassReverb(result,D5,a5);
output=AllPassReverb(result,D6,a6);
end