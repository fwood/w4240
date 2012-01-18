function lb = variational_lower_bound(r,alpha,m,W,nu,beta,X)
% This function calculates the variational lower bound.  This value should
% go up as the algorithm progresses.  The algorithm only stops when the
% variational lower bound has stopped increasing.
%
%@param r           : n x k matrix for distribution of z_i
%@param alpha       : k x 1 matrix of positive dirichlet parameters
%@param m           : d x k matrix of means
%@param W           : k long cell array of d x d covariance matrics 
%@param nu          : k x 1 matrix of degrees of freedom for W matrices
%@param beta        : k x 1 matrix of scaling factors for NIW distributions
%@param X           : n x d data matrix
%
%@return lb         : calculated scalar lower bound

global m_0 b_0 a_0 W_0 nu_0

[N D] = size(X);
K = size(r,2);

N_k = sum(r,1) * .99  + .01 * N / K;

X_bar_k = zeros(D,K);
for k = 1 : K
    X_bar_k(:,k) = sum(X .* repmat(r(:,k),1,D))' / N_k(k);
end

S_k = cell(K,1);
for k = 1 : K
    S_k{k} = zeros(D);
    for n = 1 : N
        S_k{k} = S_k{k} + r(n,k) * (X(n,:)' - X_bar_k(:,k)) * (X(n,:)' - X_bar_k(:,k))';
    end
    S_k{k} = S_k{k} / N_k(k);
end

ln_pi_tilde = psi(alpha) - psi(sum(alpha));

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

t_10_71 = 0;
for k = 1 : K
    t_10_71 = t_10_71 + N_k(k) * (Lambda_tilde(k) - D / beta(k) - nu(k) * trace(S_k{k} * W{k}) ...
        - nu(k)*(X_bar_k(:,k) - m(:,k))' * W{k} * (X_bar_k(:,k) - m(:,k)) - D * log(2 * pi));
end
t_10_71 = t_10_71 / 2;


t_10_72 = sum(sum(r .* repmat(ln_pi_tilde',n,1)));

t_10_73 = (a_0 - 1) * sum(ln_pi_tilde) + gammaln(k * a_0) - k * gammaln(a_0);

t_10_74 = K * lnB(W_0, nu_0) + (nu_0 - D - 1) / 2 * sum(Lambda_tilde);
for k = 1 : K
    t_10_74 = t_10_74 + 1 / 2 * (D * log(b_0 / 2 * pi) + Lambda_tilde(k) - ...
        D * b_0 / beta(k) - b_0 * nu(k) * (m(:,k) - m_0)' * W{k} * (m(:,k) - m_0));
    t_10_74  = t_10_74 - 1 / 2 * nu(k) * trace(inv(W_0)* W{k});
end

t_10_75 = sum(sum(r .* log(r)));

t_10_76 = sum((alpha - 1).*ln_pi_tilde) + gammaln(sum(alpha)) - sum(gammaln(alpha));

t_10_77 = 0;
for k = 1 : K
    t_10_77 = t_10_77 + 1 / 2 * Lambda_tilde(k) + D / 2 * log(beta(k) / (2 * pi)) ...
        - D / 2 + lnB(W{k},nu(k)) + (nu(k) - D - 1) / 2 * Lambda_tilde(k)  - nu(k) * D / 2; 
end


lb = t_10_71 + t_10_72 + t_10_73 + t_10_74 - t_10_75 - t_10_76 - t_10_77;

