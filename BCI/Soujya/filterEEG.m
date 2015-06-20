function[S]=filterEEG(S,st,ed,Fs) 


 stp=[st ed]/Fs;
 S=permute(S,[2 1 3]);
 N=80;
 parfor t=1:size(S,3)
 S(:,:,t)= filtfilt(fir1(N,stp),1,S(:,:,t));
 end
 S=ipermute(S,[2 1 3]);
end