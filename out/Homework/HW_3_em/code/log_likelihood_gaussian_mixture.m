function ll = log_likelihood_gaussian_mixture(data,mu,sigma,pi)
% Calculates the log likelihood of the data given the parameters of the
% model
%
% @param data   : each row is a d dimensional data point
% @param mu     : a d x k dimensional matrix with columns as the means of
% each cluster
% @param sigma  : a cell array of the cluster covariance matrices
% @param pi     : a column matrix of probabilities for each cluster
%
% @return ll    : the log likelihood of the data (scalar)
