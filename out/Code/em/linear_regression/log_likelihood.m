function ll = log_likelihood(X,Y,m,beta)

lik = normpdf(Y - X*m,0,sqrt(1/beta));
ll = sum(log(lik));

