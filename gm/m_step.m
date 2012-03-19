function [mu,sigma,pi] = m_step(data,gamma)
% Performs the M-step of the EM algorithm for gaussain mixture model.
%
% @param data   : n x d matrix with rows as d dimensional data points
% @param gamma  : n x k matrix of resposibilities
%
% @return mu    : d x k matrix of maximized cluster centers
% @return sigma : cell array of maximized 
%

k = size(gamma,2);
[n d] = size(data);

N = sum(gamma,1);

mu = zeros(d,k);
sigma = cell(k,1);
for i = 1:k
    %get mu
    mu(:,i) = 1.0 / N(i) * sum(repmat(gamma(:,i),1,d) .* data)';

    %do sigma
    S = zeros(d);
    for j = 1:n
        diff = data(j,:)' - mu(:,i);
        S = S + gamma(j,i) * diff * diff';
    end
    
    sigma{i} = S / N(i);
    
%     while ~is_postive_semi_definite(sigma{i})
%         sigma{i} = sigma{i} + eye(d) * .01;
%     end
    %sigma{i} = sigma{i} + 0.01 * eye(d); 
end

%do pi
pi = N' / n; 