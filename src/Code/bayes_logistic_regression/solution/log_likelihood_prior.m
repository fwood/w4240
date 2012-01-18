function log_likelihood = log_likelihood_prior(beta, sigma, a, b, mu)
%@param beta  :     k x 1 vector of coefficients in linear model
%@param sigma :     scalar which is covariance of beta values in prior
%@param a     : scalar prior parameter in gamma prior on precision
%@param b     : scalar prior parameter in gamma prior on precision
%@param mu    : k x 1 vector which is mean of prior on beta

log_likelihood = log(gampdf(1 / sigma,a, b)) + log(mvnpdf(beta,mu,sigma * eye(size(beta,1))));