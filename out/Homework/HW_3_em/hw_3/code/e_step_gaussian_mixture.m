function gamma = e_step_gaussian_mixture(data,pi,mu,sigma)
% Returns a matrix of responsibilities.
%
% @param    data : data matrix n x d with rows as elements of data
% @param    pi   : column vector of probabilities for each class
% @param    mu   : d x k matrix of class centers listed as columns
% @param    sigma: cell array of class covariance matrices (d x d)
%
% @return   gamma: n x k matrix of responsibilities