function r = get_r(alpha,m,W,nu, beta,X)
% This function calculates a matrix r which are parameters of the
% distribution over assignments for each row of the data matrix X.  The
% upated r is based on the values alpha, m, W, nu, and beta.
%
%@param alpha       : k x 1 matrix of positive dirichlet parameters
%@param m           : d x k matrix of means
%@param W           : k long cell array of d x d covariance matrics 
%@param nu          : k x 1 matrix of degrees of freedom for W matrices
%@param beta        : k x 1 matrix of scaling factors for NIW distributions
%@param X           : n x d data matrix
%
%@return r          : n x k matrix for distribution of z_i

[N D] = size(X);
K = size(alpha,1);

pi_tilde = psi(alpha) - psi(sum(alpha));

Lambda_tilde = zeros(K,1);
for k = 1 : K
    for d = 1 : D
        Lambda_tilde(k) = Lambda_tilde(k) + psi((nu(k) + 1 - d) / 2);
    end
    Lambda_tilde(k) = Lambda_tilde(k) + D * log(2) + log(det(W{k}));
end

E_10_64 = zeros(N,K);
for n = 1 : N
    for k = 1 : K 
        E_10_64(n,k) = D / beta(k) + nu(k) * (X(n,:) - m(:,k)') * W{k} * (X(n,:) - m(:,k)')';
    end
end

rho = -1 * E_10_64 / 2 - D * log(2 * pi) / 2 + (1 / 2) * repmat(Lambda_tilde',n,1) + repmat(pi_tilde',n,1);
r = exp(rho);

r = r ./ repmat(sum(r,2),1,K);