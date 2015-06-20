function [output]=reverbatingdelay(data,a,b,c,D)
num=b*[zeros(1,D-1) 1];
den=[ 1 zeros(1,D-1) -a];
out=filter(num,den,data);
output=out+c;