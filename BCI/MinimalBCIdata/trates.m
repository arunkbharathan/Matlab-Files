load data_set_IVb_al_train
flt = @(f)(f>7&f<30).*(1-cos((f-(7+30)/2)/(7-30)*pi*4));
[S,T,w,b] = train_bci(single(cnt), nfo.fs, ...
    sparse(1,mrk.pos,(mrk.y+3)/2),[0.5 3.5],flt,3,200);
 
load data_set_IVb_al_test
for x=1:length(cnt)
    y(x) = test_bci(single(cnt(x,:)),S,T,w,b); 
end
 
load true_labels
plot((1:length(cnt))/nfo.fs,[y/sqrt(mean(y.*y)); true_y']);
xlabel('time (seconds)'); ylabel('class');