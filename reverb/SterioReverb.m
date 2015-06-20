% Import a stereo wav file to workspace, name it as data.
Xl=[data(:,1)' zeros(1,2*fs)];
Xr=[data(:,2)' zeros(1,2*fs)];
L=length(Xr);

cl=0.5;cr=0.5;
sl=0;sr=0;
bl=0.8;br=0.8;
al=0.2;ar=0.2;
dl=0.5;dr=0.5;
Dl=2000;Dr=6000;

Yl(1:Dl-1)=Xl(1:Dl-1);
Yr(1:Dr-1)=Xr(1:Dr-1);
[D ind]=min([Dl Dr]);
Diff=abs(Dl-Dr);

for i=1:L
    Yl(i)=cl*Xl(i)+sl;
    Yr(i)=cr*Xr(i)+sr;
    
    if(i>D)
    if((i-Dl)>0 && i<length(data)+Dl)
        tempsl=sl;
    sl=bl*Xl(i-D)+al*sl+dr*sr;
    else
        sl=0;
    end
    
    if((i-Dr)>0 && i<length(data)+Dr)
    sr=br*Xr(i-D)+ar*sr+dl*tempsl;
    else
        sr=0;
    end
    
    end
    tempsl=0;
   end
dataout=[Yl' Yr'];
beep
soundsc(data,fs)
soundsc(dataout,fs)