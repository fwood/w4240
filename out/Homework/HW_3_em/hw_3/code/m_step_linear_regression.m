function [alpha beta] = m_step_linear_regression(X, Y, m, s)
% M-step of EM algorithm
%
% @param X      : design matrix for regression (n x d, includes intercept)
% @param Y      : target vector
% @param m      : mean of weight vector
% @param s      : covariance matrix of weight vector
%
% @return alpha : weight precision = 1/(weight variance)
% @return beta  : noise precision = 1 / (noise variance)