function [x,fval,exitflag,output,lambda,grad,hessian] = untitled(x0,MaxFunEvals_Data,MaxIter_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fmincon');
%% Modify options setting
options = optimoptions(options,'Display', 'final-detailed');
options = optimoptions(options,'MaxFunEvals', MaxFunEvals_Data);
options = optimoptions(options,'MaxIter', MaxIter_Data);
options = optimoptions(options,'PlotFcns', {  @optimplotx @optimplotfunccount @optimplotfval @optimplotstepsize });
options = optimoptions(options,'Algorithm', 'sqp');
options = optimoptions(options,'Diagnostics', 'on');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@objfcn,x0,[],[],[],[],[],[],@nonlconstr,options);
