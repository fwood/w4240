function log_likelihood = log_likelihood_parameters(beta, sigma, a, b, mu)

log_likelihood = log(gampdf(1 / sigma,a, b)) + log(mvnpdf(beta,mu,sigma * eye(size(beta,1))));

end