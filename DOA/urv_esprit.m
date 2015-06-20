function [angles,traj,M] =  ...
  urv_esprit(delta,X,meth,tol,theta,plotting,film)
%*******************************************************
% This function calculates URV-ESPRIT estimator for
% (non)uniform linear array.
%
% Inputs
%    delta    pair-sensors separation in wavelength
%    X        sensor output matrix - size 2m x n
%             X = [X1; X2] corresponding to sensor pairs       
%    meth     = mu \in (0,1], for method based on forgetting factor
%             = win >= size(X,1), for moving window (lag at least 
%                                 as large as number of receivers)
%    theta    true angles (for plotting purpose)
%    plotting = 0, for supressing the plots
%             = 1, else (default)
%    film     = 0, for not memorizing the movie of the simulation (default)
%             ~= 0, else.
%
% Output
%    angles  estimated angles in degrees
%    traj    trajectory of angles in time
%    M       movie of trajectory     
%*******************************************************

% Contributor: Diana Sima, KU Leuven, March 2004.


twpi = 2.0*pi;
derad = pi / 180.0;
radeg = 180.0 / pi;
j = sqrt(-1);

% initialization
[m2,n] = size(X); m = m2/2; mwin = m2;

if meth<=1, mu = meth;             % forgetting factor
else if meth<m2, mwin = m2;        % lag of moving window
    else mwin = meth;
    end
end

if (nargin<4) | (isempty(tol))
  tol = 1e-2;   % open problem:  automatic determination of tol
end

if (nargin>=5) 
  if (~isempty(theta))
    L = size(theta,1); 
  end
else 
  L = 0; 
end

if nargin<6, plotting = 1; end, 

if nargin<7, film = 0; end


R = zeros(mwin); V = eye(mwin); d = 0;

[d,R,V] = lurv(X(:,1:mwin)',tol,4,4); 

[R,V]   = urv_qrit(d,25,R,V); 

Xwin = X(:,1:mwin)'; 
R = R(1:m2,1:m2);

kframe = 1; traj = [];

% simulate online processing
for i = mwin+1:n

  if meth<=1
    
    [d,R,V,U,vec] = urv_up(d,R,V,[],X(:,i)',mu,tol); 
    Xwin = [mu*Xwin;X(:,i)']; 
    if rem(i,mwin) == 0
      [d,R,V] = lurv_a(Xwin,tol); R = R(1:m2,1:m2); 
      % update - to account for loss of accuracy due to ???
    end
    
  else
    
    [d,R,V] = urv_win(d,R,V,[],Xwin,X(:,i)',1,tol); 
    Xwin = [Xwin(2:end,:);X(:,i)']; 
    if rem(i,mwin) == 0
      [d,R,V] = lurv_a(Xwin,tol); R = R(1:m2,1:m2); 
      % update - to account for deorthogonalization due to downdating
    else        
      R(d+1:end,:) = zeros(m2-d,m2); R(1:d,d+1:end) = zeros(d,m2-d);
    end
    
  end

  if rem(i,mwin) == 0  %'true' %
    Ex = V(:,1:d);                              
    % basis for signal subspace
    Ex = [Ex(1:m,:), Ex(m+1:m2,:)];             
    % partition w.r.t. 2 sets of sensors
    
    if 2*d<=m
      [p,Phi,W] = lurv_a(Ex,0);            % URV decomposition of Ex
    else
      warning('too few sensors'); W = eye(2*d); 
    end
    
    V12 = W(1:d,d+1:2*d); V22 = W(d+1:2*d,d+1:2*d);  % partition V
    phi = -eig(V12,V22);                             % phase estimates
    ephi = atan2(imag(phi), real(phi));              % DOA estimates
    angles = - asin( ephi / twpi / delta ) * radeg;  
    angles = sort(angles);

    % plot
    if plotting~=0
      
      if L>0, thetaux = sort(theta(:,i-mwin/2)); end              
      % plot true angle at an earlier time instant
      for k = 1:max(d,L)
        set(gca,'Fontsize',12)
        if k<=L,  
          polar([0 thetaux(k)*derad],[0 1],'b-.>') 
          hold on
        end 
        if k<= d, 
          polar([0 angles(k)*derad],[0 .5],'r->')
          hold on
        end
      end
      set(gca,'Fontsize',15)
      
      if L>0
        legend(['true:            ', num2str(thetaux(1:L)','%.1f  ')],...
               ['estimated:  ',num2str(angles','%.1f  ')],3)
      else
        legend(['estimated:  ',num2str(angles','%.1f  ')],3)
      end
             
      set(gcf,'nextplot','replacechildren'); 
      pause(.01), hold off
      
      if film~=0, M(kframe) = getframe(gcf); end
    end

    kframe = kframe+1; 
    traj{kframe} = angles';
    
  end
  
end
%
% End urv_esprit.m
