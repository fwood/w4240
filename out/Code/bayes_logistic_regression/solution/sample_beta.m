function beta = sample_beta(beta, sigma, X, Y, a, b, mu)
%@param beta  : k x 1 matrix column matrix of coefficient parameters of linear model
%@param sigma : scalar, variance of beta vector in prior
%@param X     : n x k design matrix
%@param Y     : n x 1 column vector of binary ({0,1}) outcomes
%@param a     : scalar prior parameter in gamma prior on precision
%@param b     : scalar prior parameter in gamma prior on precision
%@param mu    : k x 1 vector which is mean of prior on beta
%
%@param beta  : sampled values of beta


scaling = 1.4;

proposal_cov{1} = scaling * [1.8732   -0.0896   -0.1116   -0.4708
   -0.0896    1.6726   -0.2067    0.0172
   -0.1116   -0.2067    1.8037    0.0133
   -0.4708    0.0172    0.0133    0.1274];

proposal_cov{2} = scaling * [ 1.9926    0.0085   -0.0428   -0.4463
    0.0085    0.1188   -0.0072   -0.0198
   -0.0428   -0.0072    0.1788   -0.0682
   -0.4463   -0.0198   -0.0682    0.2211];

ll = logistic_log_likelihood(beta, X, Y) + log_likelihood_prior(beta, sigma, a, b, mu);

beta_prop = mvnrnd(beta(1:4),proposal_cov{1});
ll_prop = logistic_log_likelihood([beta_prop' ; beta(5:8)], X, Y) + log_likelihood_prior([beta_prop' ; beta(5:8)], sigma, a, b, mu);

r = exp(ll_prop - ll);
if rand < r
    beta(1:4) = beta_prop;
    ll = ll_prop;
end

beta_prop = mvnrnd(beta(5:8),proposal_cov{2});
ll_prop = logistic_log_likelihood([beta(1:4) ; beta_prop'], X, Y) + log_likelihood_prior([beta(1:4) ; beta_prop'], sigma, a, b, mu);

r = exp(ll_prop - ll);
if rand < r
    beta(5:8) = beta_prop;
end
