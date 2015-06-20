let=[];multiWaitbar( 'Decompressing', 0, 'Color', 'r' );
for i=1:l
ind=length(PC)-sum(PC>V);
let=[let alpha{ind,1}];
nLOW =PC(ind);
nRANGE=P(ind);
V = vpa((V-nLOW)/nRANGE);
 multiWaitbar( 'Decompressing', i/l );
end
 multiWaitbar( 'CloseAll' );
let