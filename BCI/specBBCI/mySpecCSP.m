 clear;load('FIL5_35Competition_train.mat');

signal.srate=1000;signal.data=S;signal.label=Y;steps=3;n_of=3;q=1;p=1;
prior = @(f) f>=7 & f<=30;
ind=@(c) (c+3)/2;
% number of C=Channels, S=Samples and T=Trials #ok<NASGU>
            [C,S,dum] = size(signal.data); %#ok<NASGU>
            % build a frequency table (one per DFT bin)
            freqs = (0:S-1)*signal.srate/S;
            % evaluate the prior I
            I = prior(freqs);
            % and find table indices that are supported by the prior
            bands = find(I);
            
            % preprocessing
            for c=-1:2:1
                
                % compute the per-class epoched data X and its Fourier transform (along time), Xfft
                X{ind(c)} = signal.data(:,:,(Y==c));
                [C,S,T] = size(X{ind(c)});
                 Xfft{ind(c)} = fft(X{ind(c)},[],2);

                % the full spectrum F of covariance matrices per every DFT bin and trial of the data
                F{ind(c)} = single(zeros(C,C,max(bands),T));
                for k=bands
                    for t=1:T
                        F{ind(c)}(:,:,k,t) = 2*real(Xfft{ind(c)}(:,k,t)*Xfft{ind(c)}(:,k,t)'); end
                end
                % compute the cross-spectrum V as an average over trials
                V{ind(c)} = mean(F{ind(c)},4);
            end
            
            % 1. initialize the filter set alpha and the number of filters J
            J = 1; alpha{J}(bands) = 1;
            % 2. for each step
            for step=1:steps
                % 3. for each set of spectral coefficients alpha{j} (j=1,...,J)
                for j=1:J
                    % 4. calculate sensor covariance matrices for each class from alpha{j}
                    for c = -1:2:1
                        Sigma{ind(c)} = zeros(C);
                        for b=bands
                            Sigma{ind(c)} = Sigma{ind(c)} + alpha{j}(b)*V{ind(c)}(:,:,b); end
                    end
                    % 5. solve the generalized eigenvalue problem Eq. (2)
                    [VV,DD] = eig(Sigma{1},Sigma{1}+Sigma{2});
                    % and retain n_of top eigenvectors at both ends of the eigenvalue spectrum...
                    W{j} = {VV(:,1:n_of), VV(:,end-n_of+1:end)};
                    iVV = inv(VV)'; P{j} = {iVV(:,1:n_of), iVV(:,end-n_of+1:end)};
                    % as well as the top eigenvalue for each class
                    lambda(j,:) = [DD(1), DD(end)];
                end
                % 7. set W{c} from all W{j}{c} such that lambda(j,c) is minimal/maximal over j
                W = {W{argmin(lambda(:,1))}{1}, W{argmax(lambda(:,2))}{2}};
                P = {P{argmin(lambda(:,1))}{1}, P{argmax(lambda(:,2))}{2}};
                % 8. for each projection w in the concatenated [W{1},W{2}]...
                Wcat = [W{1} W{2}]; J = 2*n_of;
                Pcat = [P{1} P{2}];
                for j=1:J
                    w = Wcat(:,j);
                    % 9. calcualate (across trials within each class) mean and variance of the w-projected cross-spectrum components
                    for c=-1:2:1
                        % part of Eq. (3)
                        s{ind(c)} = zeros(size(F{ind(c)},4),max(bands));
                        for k=bands
                            for t = 1:size(s{ind(c)},1)
                                s{ind(c)}(t,k) = w'*F{ind(c)}(:,:,k,t)*w; end
                        end
                        mu_s{ind(c)} = mean(s{ind(c)});
                        var_s{ind(c)} = var(s{ind(c)});
                    end
                    % 10. update alpha{j} according to Eqs. (4) and (5)
                    for c=-1:2:1
                        for k=bands
                            % Eq. (4)
                            alpha_opt{ind(c)}(k) = max(0, (mu_s{ind(c)}(k)-mu_s{3-ind(c)}(k)) / (var_s{1}(k) + var_s{2}(k)) );
                            % Eq. (5), with prior from Eq. (6)
                            alpha_tmp{ind(c)}(k) = alpha_opt{ind(c)}(k).^q * (I(k) * (mu_s{1}(k) + mu_s{2}(k))/2).^p;
                        end
                    end
                    % ... as the maximum for both classes
                    alpha{j} = max(alpha_tmp{1},alpha_tmp{2});
                    % and normalize alpha{j} so that it sums to unity
                    alpha{j} = alpha{j} / sum(alpha{j});
                end
            end
             alpha = [vertcat(alpha{:})'; zeros(S-length(alpha{1}),length(alpha))];
            model = struct('W',{Wcat},'P',{Pcat},'alpha',{alpha},'freqs',{freqs},'bands',{bands});      
            np=3;
            for p=1:np*2
            subplot(3,2,p);
                alpha = model.alpha(:,p);
                range = 1:max(find(alpha)); %#ok<MXFND>
                pl=plot(model.freqs(range),model.alpha(range,p));
                l1 = xlabel('Frequency in Hz');
                l2 = ylabel('Weight');
                t=title(['Spec-CSP Pattern ' num2str(p)]);
                
%                     set([gca,t,l1,l2],'FontUnits','normalized');
%                     set([gca,t,l1,l2],'FontSize',0.2);
%                     set(pl,'LineWidth',3);
              
            end
            
            features = zeros(size(signal.data,3),size(model.W,2));
            for t=1:size(signal.data,3)
                features(t,:) = log(var(2*real(ifft(model.alpha.*fft(signal.data(:,:,t)'*model.W))))); end         
            TC=LDA(features,Y);
            L = [ones(size(features,1),1) features] * TC';
%             Prob = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
revind=@(c) (2*c-3);
[a b]=max(L,[],2)
a=revind(b);
sum(Y==a)/278*100