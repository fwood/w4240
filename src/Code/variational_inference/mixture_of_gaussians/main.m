function main

[data classes] = test_data();

load fisheriris
data = meas;
classes(1:50) = 1;
classes(51:100) = 2;
classes(101:150) = 3;

figure(1)
scatter(data(:,1),data(:,2),[],classes,'x');


X = data;

%D dimension of input
%N fac_params_stats.number of observations
[N, D] = size(X);

%K is maximum fac_params_stats.number of clusters
K = 10;

%hyper parameters
hyper_params.beta_0 = 1;
hyper_params.m_0 = zeros(1,D);
hyper_params.W_0_inv = inv(eye(D,D));
hyper_params.nu_0 = D;
hyper_params.alpha_0 = 1;

%set up vars, naming corresponds to PRML Chapter 10 section 2.
fac_params_stats.rho = rand(N,K); % random initial responsibilities
fac_params_stats.m = zeros(1,D,K);
fac_params_stats.W_inv = zeros(D,D,K);
fac_params_stats.W = zeros(D,D,K);
fac_params_stats.nu = zeros(1,K);
fac_params_stats.beta = zeros(1,K);
fac_params_stats.S = zeros(D,D,K);
fac_params_stats.x_bar = zeros(1,D,K);
fac_params_stats.N = zeros(1,K);
fac_params_stats.alpha = zeros(1,K);
fac_params_stats.E_ln_pi = zeros(1,K);
fac_params_stats.E_ln_det_Lambda = zeros(1,K);


max_loops = 100;
evidence_bound = zeros(max_loops,1);

loop = 1;
not_converged =1;
while not_converged && loop <= max_loops 
    
    % normalize the responsibilities
    r = fac_params_stats.rho ./ repmat(sum(fac_params_stats.rho,2),1,K);
    
    map_classes = zeros(size(classes));
    
    for n=1:N
        [ v map_classes(n)] = max(r(n,:));
    end
    
    figure(2)
    scatter(data(:,1),data(:,2),[],map_classes,'x');
    drawnow
    
    for k = 1:K
        % compute group statistics
        fac_params_stats.N(k) = sum(r(:,k));
        x_bar_tmp = repmat(r(:,k),1,D).*X;
        fac_params_stats.x_bar(1,:,k) = (1/fac_params_stats.N(k)) * sum(x_bar_tmp);
        S_tmp = X - repmat(fac_params_stats.x_bar(1,:,k),N,1);
        fac_params_stats.S(:,:,k) = S_tmp' * (repmat(r(:,k),1,D).*S_tmp) * (1/fac_params_stats.N(k)); % check this
        

        
        % - check computation above by unrolling
        S = zeros(D,D);
        
        for n = 1:N
           S = S+ r(n,k) * (X(n,:) - fac_params_stats.x_bar(1,:,k))'*((X(n,:) - fac_params_stats.x_bar(1,:,k)));
        end
        S = (1/fac_params_stats.N(k)) * S;
        
        %figure(2)
        %hold on; plotMVNIsosurfaces(fac_params_stats.x_bar(1,:,k)',fac_params_stats.S(:,:,k),'k',gca); hold off; 
        %drawnow
        
        
        
        fac_params_stats.beta(k) = hyper_params.beta_0 + fac_params_stats.N(k);
        fac_params_stats.m(:,:,k) = (1/fac_params_stats.beta(k))*(hyper_params.beta_0 * hyper_params.m_0 + fac_params_stats.N(k) * fac_params_stats.x_bar(1,:,k));
        fac_params_stats.W_inv(:,:,k) = (hyper_params.W_0_inv + fac_params_stats.N(k) *fac_params_stats.S(:,:,k) + (hyper_params.beta_0*fac_params_stats.N(k))/(hyper_params.beta_0+fac_params_stats.N(k)) * (fac_params_stats.x_bar(1,:,k) - hyper_params.m_0)*((fac_params_stats.x_bar(1,:,k) - hyper_params.m_0)'));
        fac_params_stats.nu(k) = hyper_params.nu_0 + fac_params_stats.N(k) +1;
        
        fac_params_stats.alpha(k) = hyper_params.alpha_0 + fac_params_stats.N(k);
        fac_params_stats.E_ln_pi(k) = psi(fac_params_stats.alpha(k)) - psi(K*hyper_params.alpha_0 + N);
        
        fac_params_stats.W(:,:,k) = pinv(fac_params_stats.W_inv(:,:,k));
        fac_params_stats.E_ln_det_Lambda(k) = sum(psi((fac_params_stats.nu(k) + 1 - [1:D])/2)) + D*log(2) + log(det(fac_params_stats.W(:,:,k)));
        
                E = 0;
                for d = 1:D
                    E = E + psi((fac_params_stats.nu(k) +1 -d)/2) ;
                end
                E = E +  D* log(2) + log(det(pinv(fac_params_stats.W_inv(:,:,k))));
        
        for n = 1:N
            E_mu_k_Lambda_k_quad_form = D*(1/fac_params_stats.beta(k)) + fac_params_stats.nu(k) * (X(n,:) - fac_params_stats.m(:,:,k)) * fac_params_stats.W(:,:,k) * ((X(n,:) - fac_params_stats.m(:,:,k))');
            
            fac_params_stats.rho(n,k) = exp(fac_params_stats.E_ln_pi(k)  + (1/2)*fac_params_stats.E_ln_det_Lambda(k) - (D/2) * log(2*pi) - (1/2) * E_mu_k_Lambda_k_quad_form);
        end
        
    end
    
    lb = gmm_variational_lower_bound(hyper_params, fac_params_stats);
    evidence_bound(loop) = lb;
    
    figure(3)
    plot(1:loop, evidence_bound(1:loop))
    xlabel('VB Iteration');
    ylabel('Evidence Bound');
    drawnow
    
    disp(['Loop ' num2str(loop) '/' num2str(max_loops) ', bound ' num2str(evidence_bound(loop)) ]);
    loop = loop +1;

end

