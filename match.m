[s_matched signal_noise noise]=match(signal_fad,snr_db(z))
E=10^(Eb(k)/10);
AWGN_NOISE=random('Normal',0,1,1,symbol_number*N);
  received_signal=awgn(message,Eb(k));