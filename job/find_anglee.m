function[anglee]=find_anglee(X,Y)
x1=X(1);x2=X(2);x3=X(3);
y1=Y(1);y2=Y(2);y3=Y(3);
if(sum(sign(Y-y1))==0)
   Ymid=y1;Xmid=x1;
   Ylo=Y(find(sign(Y-y1)==1));Xlo=X(find(sign(Y-y1)==1));
   Yup=Y(find(sign(Y-y1)==-1));Xup=X(find(sign(Y-y1)==-1));
end
if(sum(sign(Y-y2))==0)
    Ymid=y2;Xmid=x2;
   Ylo=Y(find(sign(Y-y2)==1));Xlo=X(find(sign(Y-y2)==1));
   Yup=Y(find(sign(Y-y2)==-1));Xup=X(find(sign(Y-y2)==-1));
end
if(sum(sign(Y-y3))==0)
   Ymid=y3;Xmid=x3;
   Ylo=Y(find(sign(Y-y3)==1));Xlo=X(find(sign(Y-y3)==1));
   Yup=Y(find(sign(Y-y3)==-1));Xup=X(find(sign(Y-y3)==-1));
end

a1=polyfit([Xup Xmid],[Yup Ymid],1);
a2=polyfit([Xmid Xlo],[Ymid Ylo],1);
vect1 = [1 a1(1)];
vect2 = [1 a2(1)];
dp = dot(vect1, vect2);
length1 = sqrt(sum(vect1.^2));
length2 = sqrt(sum(vect2.^2));
% angle = 180-acos(dp/(length1*length2))*180/pi
% intersection = [1 ,-a1(1); 1, -a2(1)] \ [a1(2); a2(2)]
anglee=acos(dp/(length1*length2))*180/pi;
