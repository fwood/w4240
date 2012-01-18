function theta = sample_theta(Z, alpha, A,M,K)

for m = 1 : M
    counts = alpha * ones(K,1);
    for k = 1 : K
        counts(k) = counts(k) + sum(Z{m} == k);
    end
    
    theta{m} = gamrnd(counts,1);
    theta{m} = theta{m} / sum(theta{m});
end

