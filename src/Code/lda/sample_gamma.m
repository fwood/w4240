function gamma = sample_gamma(documents, Z, beta, A, M, K)

for k = 1 : K
    counts = ones(A,1) * beta;
    for m = 1 : M
        counts = counts + sum(documents{m}(Z{m} == k),1);
    end
    gamma(:,k) = gamrnd(counts',1);
    gamma(:,k) = gamma(:,k) / sum(gamma(:,k));
end

