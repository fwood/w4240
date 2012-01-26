
function [alpha beta] = m_step(X, Y, m, s)
% M-step of EM algorithm
%
% @param X      : design matrix for regression (n x d, includes intercept)
% @param Y      : target vector
% @param m      : mean of weight vector
% @param s      : covariance matrix of weight vector
%
% @return alpha : weight precision = 1/(weight variance)
% @return beta  : noise precision = 1 / (noise variance)

[n d] = size(X);
alpha = d / (m' * m + trace(s));

l = 0;
for i = 1 : n
    diff = X(i,:) - m';
    l = l + (X(i,:) * m - Y(i))^2 + diff * s * diff';
end
beta = n / l;