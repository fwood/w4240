function [X Y weights] = generate_data(n,d,beta,alpha)

weights = mvnrnd(zeros(d + 1,1),eye(d+1)/alpha)';

X = [ones(n,1) unifrnd(-10,10,n,d)];
Y = normrnd(X*weights,sqrt(1/beta));
