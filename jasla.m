KE=200;
ex=zeros(KE,1);hy=zeros(KE,1);
kc=KE/2;
t0=40.0;
spread = 12;
T=0;
NSTEPS=1;
while(NSTEPS>0)
  NSTEPS=input('NSTEPS -->');
  disp('NSTEPS');
  n=0;
  for n=1:NSTEPS
      T=T+1;
      for k=1:(KE-.001)
          ex(k+1) = ex(k+1) + 0.5*(hy(k-1+1)-hy(k+1));
      end
     
      pulse = exp(-.5*( ((t0-T)/spread)^2.0 ));
      ex(kc) = pulse;
      formatSpec = '%5.1f  %6.2f \n';
      fprintf( formatSpec,t0-T,ex(kc));
      for k=0:(KE-1-.0001)
          hy(k+1)=hy(k+1)+.5*(ex(k+1)-ex(k+1+1));
      end
      for k=1:KE
         formatSpec = '%3d  %6.2f  %6.2f\n';
         fprintf( formatSpec,k,ex(k),hy(k)); 
      end
      fprintf('T=%5.0f\n',T)
      
  end
  
      
end
figure;subplot(211)
plot(hy);subplot(212)
plot(ex)