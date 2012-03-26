function [m s] = e_step_linear_regression(X, Y, alpha, beta)
% E-step of EM algorithm
%
% @param X      : design matrix for regression (n x d, includes intercept)
% @param Y      : target vector
% @param alpha  : weight precision = 1/(weight variance)
% @param beta   : noise precision = 1 / (noise variance)
%
% @return m     : posterior mean of weight vector
% @return s     : posterior covariance matrix of weight vector

[n,d] = size(X);

s_inv = zeros(d,d);

s_inv = eye(d,d).*alpha + (X' * X).* beta;

m = (s_inv\X' * Y).* beta;

s = inv(s_inv);