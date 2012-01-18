function [alpha,m,W,nu,beta] = get_other_parameters(r, X)
% This function calculated the updated parameter values for alpha, m, W, 
% nu, and beta given the value of r and the data matrix X.
%
%@param r           : n x k matrix for distribution of z_i
%@param X           : n x d data matrix
%
%@return alpha       : k x 1 matrix of positive dirichlet parameters
%@return m           : d x k matrix of means
%@return W           : k long cell array of d x d covariance matrics 
%@return nu          : k x 1 matrix of degrees of freedom for W matrices
%@return beta        : k x 1 matrix of scaling factors for NIW distributions

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

alpha = a_0 + N_k';
beta = b_0 + N_k';

m = zeros(D,K);
for k = 1 : K
    m(:,k) = (b_0 * m_0 + N_k(k) * X_bar_k(:,k)) / beta(k,1);
end

W = cell(K,1);
for k = 1 : K
    w = inv(W_0) + N_k(k) * S_k{k} + b_0 * N_k(k) / (b_0 + N_k(k)) * (X_bar_k(:,k) - m_0) * (X_bar_k(:,k) - m_0)';
    W{k} = inv(w);
end

nu = nu_0 + N_k';