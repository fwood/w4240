function sigma = sample_sigma(beta, a, b)
%@param beta    :   k x 1 vector of regression parameters
%@param a       :   alpha parameter in gamma prior on inv sigma
%@param b       :   beta parameter in gamma prior on inv sigma
%
%@return sigma  :   sigma sampled from the condititional distribtion

sigma_inv = gamrnd(size(beta,1) / 2 + a, 1 / (1 / b + .5 * sum(b.^2)));
sigma = 1 / sigma_inv;

