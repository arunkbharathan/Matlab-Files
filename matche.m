function [s_matched]=matche(signal_fad,Eb)
E=10^(Eb/10);

  received_signal=awgn(signal_fad,Eb);
  toconv=fliplr(signal_fad);
  s_matched=conv(received_signal,toconv);
  end