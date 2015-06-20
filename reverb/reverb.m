k=(h_air*1000)';
wavplay(k(1:3e4),48000);
% v=conv(data,k);
% wavplay(v(1:3e4),48000);
% wavplay(v(1:3e4),fs);
Y = fft(k, length(k)+length(data)-1) .* fft(data,length(k)+length(data)-1);
Y = real(ifft(Y));
wavplay(Y,48000);