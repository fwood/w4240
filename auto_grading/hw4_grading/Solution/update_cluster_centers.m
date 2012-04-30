function [new_centers assignments] = update_cluster_centers(cluster_centers,data)
% This function takes a data set, and a set of cluster centers and returns
% both the updated set of cluster centers and a center assignment variable 
% for each data point.  The data set is assumed to be arranged such that
% each row is one data d dimensional data point.  In the documentation we
% wil use k to denote the number of clusters for the k-means analysis.
%
% @param cluster_centers : k x d matrix of cluster centers
% @param data            : n x d matrix of data
%
% @return new_centers    : k x d matrix of updated cluster centers
% @return assignments    : n x 1 matrix of cluster assignments in 1:k
%

[n d] = size(data);
k = size(cluster_centers,1);
dist = pdist2(data, cluster_centers);

[~, assignments] = min(dist,[],2);

new_centers = zeros(k,d);
for i = 1 : k
    if sum(assignments==i) > 0
        new_centers(i,:) = mean(data(assignments == i,:));
    else
        new_centers(i,:) = data(ceil(unifrnd(0,n)),:);
    end    
end

figure(2)
plot_d_dimensional_mixture_data(data,assignments)