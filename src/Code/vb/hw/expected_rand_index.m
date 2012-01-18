function eri = expected_rand_index(data, r, labels)
% Given the true labels, each pair of data points is either in the same
% cluster or in different clusters.  Given a specific clustering we could
% consider all unique pairs of data points and give ourselves a penalty of 1
% if we have done the wrong thing (that is put them in the same class
% incorrectly or failed to put them in the same class). When normalized by 
% n choose 2 this penalty function is known as the Rand index. Since the result
% of a variational Bayes approach is not one specific clustering, but a
% distribution over clusterings, we can consider the expected Rand
% index.  This function is to calculate the expected Rand index.
%
%@param data    : n x d data matrix
%@param r       : n x k matrix of distributions over z
%@param labels  : n x 1 matrix of labels
%
%@return eri    : expected rand index

