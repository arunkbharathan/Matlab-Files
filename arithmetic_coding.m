function c=arithmetic_coding(A, P, Str)
%It calculate the arithmetic code of a string "Str". See http://en.wikipedia.org/wiki/Arithmetic_coding
%The source alphabet is "A" and the probability distribution is "P".



c=[0 1];

%Check input arguments
if length(A)~=length(P) 
    disp(['Source, Probability distribution and strig must have the same length']);
    return
end

if uint8(sum(P))~=1
    disp(['The second input argument must be a Probability distrubution']);
    return
end

left=0;  %left range
right=1; %right range



for i=1:length(Str)     %for each char
    search=(A==Str(i)); %Search into alphabet
    index=sum(search.*(1:length(P)));  %Calculate index into alphabet
    len=(right-left);   %length of range
    
    right=left+len*sum(P(1:index));  %update right range
    if(index==1)                     %if the char is the 1st of alphaber
        left=left;                   %the left range is the same 
    else
    left=left+len*sum(P(1:(index-1)));  %update left range
    end
       
    c=[c;left right];                %update output
end




