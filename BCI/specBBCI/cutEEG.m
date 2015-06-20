function[S]=cutEEG(S,tym1,tym2,Fs)
S=S(:,1+tym1*Fs:tym2*Fs,:);%S(elec,time,trial)
end