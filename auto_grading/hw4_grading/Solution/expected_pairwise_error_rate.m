function er = expected_pairwise_error_rate(data, r, labels)
%@param data    : n x d data matrix
%@param r       : n x k matrix of distributions over z
%@param labels  : n x 1 matrix of labels

N = size(data,1);

total = 0;
er = 0;

for i = 1 : N
    for j = (i + 1) : N
        prob_same = sum(r(i,:) .* r(j,:));
        if labels(i) == labels(j)
            er = er + 1 - prob_same;
        else
            er = er + prob_same;
        end
        total = total + 1;
    end
end

er = er / total;