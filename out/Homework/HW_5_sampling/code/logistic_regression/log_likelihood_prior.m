function log_likelihood = log_likelihood_prior(beta, sigma, a, b, mu)
%Returns the part of the joint log likelihood which has to do with the
%prior.  This added to the logistic_log_likelihood give the joint
%log likelihood.
%
%@param beta  : k x 1 vector of coefficients in linear model
%@param sigma : scalar which is covariance of beta values in prior
%@param a     : scalar prior parameter in gamma prior on precision
%@param b     : scalar prior parameter in gamma prior on precision
%@param mu    : k x 1 vector which is mean of prior on beta