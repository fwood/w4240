%This script outlines how to fit the model using a MCMC sampling technique.
%You will need to set the values of a,b, and mu.  The model uses a normal 
%prior on the covariates beta.  The parameters a and b are the two
%parameters used in the gamma prior on the precision of the covariates
%while mu is the mean.  The data is read in through get_data and the
%headers variable can be used to access the column labels.  The Y column
%vector is a binary vector indicating improvemnt over the course the course
%of the study. The model is fit using MCMC sampling.  To answer the 
%questions for the HW you need to summarize the posterior appropriately.

[X Y h] = get_data;

a = 1;
b = .1;

mu = zeros(8,1);

beta = unifrnd(-.2,.2,8,1);
sigma = 10;

iters = 1000;
beta_samp = zeros(iters,8);
sigma_samp = zeros(iters,1);
ll = zeros(iters,1);
for i = 1:iters
    sigma = sample_sigma(beta, a, b);
    beta = sample_beta(beta,sigma, X,Y,a,b,mu);
    
    ll(i) = logistic_log_likelihood(beta,X,Y) + log_likelihood_prior(beta,sigma,a,b,mu);
    beta_samp(i,:) = beta;
    sigma_samp(i) = sigma;
end

%%

figure(1)
clf
subplot(3,3,1)
plot(sigma_samp);
for i = 1:8
    subplot(3,3,i + 1);
    plot(beta_samp(:,i))
    title(h{i})
end

figure(2)
clf
plot(ll)
title('joint log lik');

burn_in = 1000;

%Put logic here to answer questions from HW assignemnt

