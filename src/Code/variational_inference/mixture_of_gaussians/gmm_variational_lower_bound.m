function lb = gmm_variational_lower_bound(hyper_params, fac_params_stats) 
% function lb = gmm_variational_lower_bound(X, hyper_params, fac_params_stats)
% 
% returns variational lower bound for gmm 
%
% @param hyper_param 
% hyper_params.beta_0 = 1;
% hyper_params.m_0 = zeros(1,D);
% hyper_params.W_0_inv = inv(eye(D,D));
% hyper_params.nu_0 = 1;
% hyper_params.alpha_0 = 1;
% 
% @param fac_params_stats 
% fac_params_stats.rho = rand(N,K); % initial responsibilities
% fac_params_stats.m = zeros(1,D,K);
% fac_params_stats.W_inv = zeros(D,D,K);
% fac_params_stats.W = zeros(D,D,K);
% fac_params_stats.nu = zeros(1,K);
% fac_params_stats.beta = zeros(1,K);
% fac_params_stats.S = zeros(D,D,K);
% fac_params_stats.x_bar = zeros(1,D,K);
% fac_params_stats.N = zeros(1,K);
% fac_params_stats.alpha = zeros(1,K);
% fac_params_stats.E_ln_pi = zeros(1,K);
% fac_params_stats.E_ln_det_Lambda = zeros(1,K);


[N, K] = size(fac_params_stats.rho);
D = length(fac_params_stats.W(:,1,1));

if hyper_params.nu_0 <= D-1
    error('hyper_params.nu_0 must be > D-1');
end

% cumulative lower bound
lb = 0;

% compute normalized responsibilities from unnormalized responsibilities
r = fac_params_stats.rho ./ repmat(sum(fac_params_stats.rho,2),1,K);

% PRML 10.71O
for k = 1:K
    lb = lb + (1/2) * fac_params_stats.N(k) *(fac_params_stats.E_ln_det_Lambda(k) ...
        - D / fac_params_stats.beta(k) ...
        - fac_params_stats.nu(k) * trace(fac_params_stats.S(:,:,k)*fac_params_stats.W(:,:,k)) ...
        - fac_params_stats.nu(k) *(fac_params_stats.x_bar(1,:,k)-fac_params_stats.m(1,:,k)) * fac_params_stats.W(:,:,k) * ((fac_params_stats.x_bar(1,:,k)-fac_params_stats.m(1,:,k))') ...
        - D*log(2*pi));
end

% PRML 10.72
for k = 1:K
    lb = lb + sum(r(:,k)*fac_params_stats.E_ln_pi(k));
end

% PRML 10.73
lb = lb + gammaln(K*hyper_params.alpha_0 + N) -sum(gammaln(fac_params_stats.alpha)) + (hyper_params.alpha_0 + 1) * sum(fac_params_stats.E_ln_pi);

% PRML 10.74
for k = 1:K
    lb = lb + (1/2) * ( D*log(hyper_params.beta_0/(2*pi)) ...
        + fac_params_stats.E_ln_det_Lambda(k) - (D*hyper_params.beta_0)/fac_params_stats.beta(k) ...
        - hyper_params.beta_0*fac_params_stats.nu(k)*(fac_params_stats.m(1,:,k) - hyper_params.m_0) * fac_params_stats.W(:,:,k) * ((fac_params_stats.m(1,:,k) - hyper_params.m_0)'));
end
lb = lb + K*logB( pinv(hyper_params.W_0_inv),hyper_params.nu_0);
lb = lb + ((hyper_params.nu_0 - D -1)/2) * sum(fac_params_stats.E_ln_det_Lambda);
for k = 1:K
    lb = lb - (1/2) * fac_params_stats.nu(k) * trace(hyper_params.W_0_inv * fac_params_stats.W(:,:,k));
end

% PRML 10.75
lb = lb + sum(sum(r .* log(r)));

% PRML 10.76
lb = lb + sum((fac_params_stats.alpha -1).*fac_params_stats.E_ln_pi) + gammaln(K*hyper_params.alpha_0 + N) -sum(gammaln(fac_params_stats.alpha));

% PRML 10.77
for k = 1:K
   lb = lb + (1/2) *  fac_params_stats.E_ln_det_Lambda(k) ...
        + (D/2) * log(fac_params_stats.beta(k) / (2*pi)) ...
        - (D/2) - H_Wishart( fac_params_stats.W(:,:,k), fac_params_stats.nu(k));
end


% helper functions for computing functionals of Wishart distributions
function ret = logB(W,nu)
D = length(W(:,1));
ret = -nu/2*log(det(W)) - ((nu*D)/2 * log(2) + D*(D-1)/4 * log(pi) + sum(gammaln((nu+1 - [1:D])/2)));

function ret = H_Wishart(W,nu)
D = length(W(:,1));
ret = -logB(W,nu) - ((nu-D-1)/2) * (sum(psi((nu + 1 - [1:D])/2)) + D * log(2) + log(det(W))) + (nu*D)/2;