function ll = log_likelihood_linear_regression(X,Y,m,beta)
% This function evaluates an approximation of the joint log likelihood.
% The estimate uses the posterior mean of the weights.  This quantity
% should increase as the algorithm progresses.

lik = normpdf(Y - X*m,0,sqrt(1/beta));
ll = sum(log(lik));

