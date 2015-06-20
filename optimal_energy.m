% Matlab code for MIMO-OFDM including BER, SNR, reyleigh.etc
% 
% matlab code for optimal energy in wireless sensor & n/w

function [Eopt,Tn]=optimal_energy(T,n,C,D,R,s,PR)

%---------------------------------------------------------------
%This algorithm uses binary search for achieve a solution
%to compute the optimal energy for each node when all the 
%nodes have the same energy levels.

%Based on paper: "Energy-Efficient Multi-Hop Packet Transmission
%using Modulation Scaling in Wireless Sensor Networks"

%---------inputs----------------------------------------
%T is the delay constraint in our system
%n is the number of transmitting nodes in the path
%C is a vector(row) that symbolizes the tx power
%D is a vector(row) that symbolizes the electronic power
%s is the packet length in bits
%PR is the precision when searching for the latency constraint
%from T*(1-E) to T*(E+1) --> values of E=from 0.00001 to 0.0001
%--------------------------------------------------------
%------------outputs-------------------------------------
%Eopt is the optimal energy that satisfies the constraints
%Tn is a vector that contains the latency of each node
%--------------------------------------------------------
%conditions for optimality: E(i)=E(i+1) for i=0,1,..,n-1;
% sum(Tn)=T;

%---------------------------------
%files asociated to this program:

%energy_model
%fixedpoint
%energy_fixedpoint
%--------------------------------

E=zeros(1,n); %energy spent of each node
Tn=zeros(1,n); %latency for each node

for i = 1:n,
Tn(i)=T./n; 
end

%compute the Emin and Emax for t=T/n
for i = 1:n,
E(i)=energy_model(C(i),D(i),R,s,Tn(i)); 
end

Emax=max(E);
Emin=min(E);



%checking if we have already the solution of the problem
j=0;
for i = 1:(n-1),
if E(i)~=E(i+1)
j=1;
end

end
%if j=0 we have finished




%main body 
%1st-> solve for the new Eopt the latency constraints
%2nd check if is optimal
%3rd if not optimal perform binary search
if j==1
b=zeros(1,n);
Tn=zeros(1,n);
Ts=sum(Tn);
Eopt=0;
else
Eopt=E(1);
%Tn=Tn;
end

while j==1,

Eopt=(Emax+Emin)./2;

for i = 1:n
E(i)=Eopt;
b(i)=fixedpoint('energy_fixedpoint',8,1e-6,1000,C(i),D(i),Eopt,s);
end


Tn=s./(b.*R);
Ts=sum(Tn);
if (Ts> (T*(PR+1))) %not optimal
Emax=Emax;
Emin=Eopt;
elseif (Ts< (T*(1-PR))) %not optimal
Emax=Eopt;
Emin=Emin;
else %is optimal
j=0;
end

end

%end of optimal_energy

