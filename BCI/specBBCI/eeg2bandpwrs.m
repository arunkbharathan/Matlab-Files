function bdpw=eeg2bandpwrs(data,iep,Fs )
%% FUNCTION eeg2bandpwrs
% You might try the following functions, which were given to me by other EEG researchers at 
% the University of Helsinki. Here, 'eeg' is an eeglab struct (obtained by reading your EEG with
% eeglab functions such as pop_biosig or pop_loadset). 'ch' is a vector of channels you want to 
% include in the estimate. 'iep' is a vector of band limits (in Hz), where each band is adjacent
% (i.e. the upper limit of band i is the lower limit of band i+1).
% Requires eeglab and dsp toolboxes.

% PURPOSE: Plot the eeg2bandpwrs from an EEG.
% PARAMS: 'eeg' - eeglab data structure
% 'ch' - channels to select
% 'iep' - band division points (in Hz) for individualisation
% USAGE:
% Note:
% CALLS:
%     nbands = numel(iep)-1;
%     bdpw = zeros(1, nbands);
    
    % Limit the data to specific channels and trim excess data
%      data = data(ch,:);
%     seg = floor(size(data,2)/(5*eeg.srate));
%     data = data(:,1:seg*5*eeg.srate);

    % Design two 4th order IIR (butterworth) bandpass filters according to the IAF-corrected frequency bands
%     Fs = eeg.srate;
    N = 10;
%     for p = 1:nbands
        Hd = design( fdesign.bandpass('N,F3dB1,F3dB2', N, iep-1, iep+1, Fs), 'butter' );
        Fd = filter(Hd, data')';
        bdpw = median( log( median(  mean(Fd.^2,1), 2 )+1 ) );
%     end