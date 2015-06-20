%run it before NoClockpll but make sure af and bf are what’s needed.
%the simulink file is NoClockpll
ko=200;
[bf,af]=butter(1,2*pi*20,'s');

w1=2*pi*30; w2=2*pi*40;
wn=2*pi*10; zeta=0.99;
af=conv(af,conv([1/w1 1],[1/w2 1]));
bf=conv(bf,[1/wn^2 2*zeta/wn 1]);

figure(1); rlocus(bf,[af 0]);
figure(1);step(ko*bf,[[af 0] + ko*[0 bf]]);
xlabel('Time'); ylabel('Voltage (V)');
title('VCO Input Voltage (Linear Simulation)');
figure(2);rlocus(bf,[af 0])
%code to plot the output from NoClockpll
if 1 > 2
figure(3);plot(Vout.time,Vout.signals.values);grid;
xlabel('Time (s)'); ylabel('Voltage (V)');
title('VCO Input Voltage (Nonlinear Simulation');
end