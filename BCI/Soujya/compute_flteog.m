function [X,hist,H_n,R_n] = compute_flteog(X,hist,H_n,R_n,eeg,eog,ffact)
% for each sample...
for n=1:size(X,2)
    % update the EOG history by feeding in a new sample
    hist = [hist(:,2:end) X(eog,n)];
    % vectorize the EOG history into r(n)        % Eq. 23
    tmp = hist';
    r_n = tmp(:);
    
    % calculate K(n)                             % Eq. 25
    K_n =  (ffact + r_n' * R_n * r_n)\R_n * r_n;
    % update R(n)                                % Eq. 24
    R_n = ffact^-1 * R_n - ffact^-1 * K_n * r_n' * R_n;
    
    % get the current EEG samples s(n)
    s_n = X(eeg,n);    
    % calculate e(n/n-1)                         % Eq. 27
    e_nn = s_n - (r_n' * H_n)';    
    % update H(n)                                % Eq. 26
    H_n = H_n + K_n * e_nn';
    % calculate e(n), new cleaned EEG signal     % Eq. 29
    e_n = s_n - (r_n' * H_n)';
    % write back into the signal
    X(eeg,n) = e_n;
end
