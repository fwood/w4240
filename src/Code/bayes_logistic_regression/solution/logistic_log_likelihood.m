function log_likelihood = logistic_log_likelihood(beta, X, Y)
%@param beta            :   k x 1 vector of regression coefficients
%@param X               :   n x k matrix of covariates
%@param Y               :   n x 1 binary response vector
%
%@return log_likelihood :   log likelihood of response given beta and X

p = 1 ./ (1 + exp(-(X * beta)));
ll = log(p) .* (Y == 1) + log(1-p) .* (Y == 0);
log_likelihood = sum(ll);