%%%
%%% DOA simulation
%%%
%
%
% for initialization, specify
% move = 0, % for stationary sources
% move = 1, % for one moving source
% move = 2  % for more than one moving source (with intersection!)
% 
% L = l, for l = 1,2,3,4,5 number of sources
%

% Contributor: Diana Sima, KU Leuven, March 2004.

j = sqrt(-1);
derad = pi/180;         % deg -> rad
twpi = 2*pi;
rad = [1:300]; n = length(rad);

K = 14;                  % number of sensors 
delta = 0.5;             % distance between sensors
d=0:delta:(K-1)*delta;      % sensors array
d = d/K/delta;

% number of signals; default 3
if (~exist('L','var')) || (L>5), L = 3;  end   

% type of movement; default one linear moving source
if (~exist('move','var')) || (move>2), move = 1; end     

if (move==0) 
    theta = [0*ones(1,n); 25*ones(1,n); 50*ones(1,n); ...
             70*ones(1,n); 90*ones(1,n)];
else if (move ==1)
       speed = .05;
       theta = [0*ones(1,n)+speed*[1:n]; 25*ones(1,n); ...
                50*ones(1,n); 70*ones(1,n); 90*ones(1,n)];
   else
       theta = [0 + 10*sin(twpi*rad/760); 20 - 10*sin(twpi*rad/960); ...
                25 + 5*sin(twpi*rad/240); 60 - 10*sin(twpi*rad/760); ...
                40 + 10*sin(twpi*rad/760)];
   end
end

theta(L+1:end,:) = [];

pw = [1 1 1 1 1];    % power of sources
cov = eye(L);        % source correlation 
nv=ones(1,K);        % normalized noise variance
snr = 1;             % input SNR (dB)

x = zeros(K,n); 
for in = 1:n
  
    % generate gaussian random variables for signals and noises
    ct = (randn(1,L)+j*randn(1,L))/sqrt(2);

    % implement source correlations
    for iL = 1:L
        cs(iL) = pw(iL)*ct(1:iL)*cov(1:iL,iL);
    end

    % generate sensor outputs
    x(:,in) = (exp(-j*twpi*d.'*sin(theta(1:L,in)'*derad))*cs.');
    
    % add noise components
    x(:,in) = x(:,in) + 1e-10*(diag(sqrt(nv*snr/2))*(randn(K,1)+j*randn(K,1)));
end


% call urv_esprit function

[angles,traj] =  urv_esprit(delta,x,K,1e-2,theta,1,0);