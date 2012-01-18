function Z = sample_assignments(documents, theta, gamma, A, M, K)

for m = 1 : M
    cd = (documents{m}*gamma).*repmat(theta{m}',size(documents{m},1),1);
    cd = cd ./ repmat(sum(cd,2),1,K);
    
    cuSum = zeros(size(documents{m},1),1);
    r = rand(size(documents{m},1),1);
    Z{m} = cuSum;
    
    for k = 1 : K
        cuSum = cuSum + cd(:,k);
        Z{m} = Z{m} + k * (cuSum > r & Z{m} == 0);
    end
end
