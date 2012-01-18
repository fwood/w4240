function [mu sigma pi] = k_means(k,data);

d = size(data,2);

mn = min(data);
mx = max(data);

mu = zeros(d,k);
for i = 1:k
    mu(:,i) = unifrnd(mn,mx);
end

for i = 1:9
    mu = update_cluster_centers(mu,data);
end
[mu assignments] = update_cluster_centers(mu,data);

sigma = cell(k,1);
pi = ones(k,1);
for i = 1 : k
    ind = assignments == i;
    pi(i,1) = pi(i,1) + sum(ind)
    if pi(i,1) > 2
        sigma{i} = cov(data(ind,:));
    else
        sigma{i} = eye(d);
    end
    
    while ~is_postive_semi_definite(sigma{i})
        sigma{i} = sigma{i} + eye(d) * .01;
    end
end



pi = pi / sum(pi);