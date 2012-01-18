function ll = joint_log_lik(doc_counts,topic_counts, alpha, gamma)

ll = 0.0;

for d = 1 : size(doc_counts,1)
    for k = 1 : size(doc_counts,2)
        ll = ll + gammaln(alpha + doc_counts(d,k));
    end
    ll = ll - gammaln(alpha * size(doc_counts,2) + sum(doc_counts(d,:)));
end

for k = 1 : size(topic_counts,1)
    cnt_zeros = sum(topic_counts(k,:) == 0);
    ll = ll + cnt_zeros * gammaln(gamma);
    for wc = topic_counts(k,(topic_counts(k,:) ~= 0));
        ll = ll + gammaln(gamma + wc);
    end
    ll = ll - gammaln(gamma * size(topic_counts,2) + sum(topic_counts(k,:)));
end

% function ll = joint_log_lik(documents,Z,theta, gamma, alpha, beta,A,M,K)
% 
% ll = 0.0;
% 
% for k = 1 : K
%     ll = ll + sum((beta - 1) * log(gamma(:,k)));
% end
% 
% for m = 1 : M
%     ll = ll + sum((alpha - 1) * log(theta{m}));
% end
% 
% for m = 1 : M
%     for k = 1 : K
%         ll = ll + sum(Z{m} == k) * log(theta{m}(k));
%     end
% end
% 
% for m = 1 : M
%     prod_mat = documents{m} * gamma;
%     ll = ll + sum(log(prod_mat(Z{m})));
% end