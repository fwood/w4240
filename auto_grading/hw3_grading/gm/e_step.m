function gamma = e_step(data,pi,mu,sigma)
% Returns a matrix of responsibilities.
%
% @param    data : data matrix n x d with rows as elements of data
% @param    pi   : column vector of probabilities for each class
% @param    mu   : d x k matrix of class centers listed as columns
% @param    sigma: cell array of class covariance matrices (d x d)
%
% @return   gamma: n x k matrix of responsibilities

k = size(pi,1);
n = size(data,1);

gamma = zeros(n,k);
for i = 1:k
    gamma(:,i) = pi(i) * mvnpdf(data,mu(:,i)',sigma{i});
end

gamma = gamma ./ repmat(sum(gamma,2),1,k);

e = .05;
gamma = gamma * (1 - e) + ones(size(gamma)) * e / k;