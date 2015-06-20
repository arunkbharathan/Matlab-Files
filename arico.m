% http://www.cs.ucf.edu/courses/cap5015/Arithmetic_coding_modified_2005.pdf
function [V,l,P]=arico(varargin)
c=varargin{1,1};
alpha={int8(zeros(1,length(c)))};
for i=1:length(c)
    alpha{i}=c(i);
end
digits(10000);
alpha=alpha';
if(nargin==1)
[p alpha]=cellhist((alpha));
P=p/sum(p);
end
PC=cumsum(P);PC=[0;PC];ind=find(ismember(alpha,c(1)));
LOW=PC(ind);RANGE=P(ind);l=length(c);
multiWaitbar( 'Compressing', 0, 'Color', 'r' );
for i=2:l
    ind=find(ismember(alpha,c(i)));
    LOW=vpa(LOW+PC(ind)*RANGE);
    RANGE=vpa(RANGE*P(ind));
    multiWaitbar( 'Compressing', i/l );
%      if abort
%         % Here we would normally ask the user if they're sure
%         break
end
beep
V=LOW+RANGE/2;
 multiWaitbar( 'CloseAll' );close all
end