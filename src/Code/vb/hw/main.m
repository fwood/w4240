%Main file for variational gaussian mixture modeling
clear
clf

load fisheriris
group(1:50,1) = 1;
group(51:100,1) = 2;
group(101:150,1) = 3;

figure(1)
plot_d_dimensional_mixture_data(meas,group)

global m_0 b_0 a_0 W_0 nu_0

[N D]  = size(meas);
K = ?;	 % max number of clusters

assignments = k_means(K,meas);
r = (ones(N,K) / K) * .1;
for k = 1 : K
    r(:,k) = r(:,k) + .9 * (assignments == k);
end

m_0 = ?;  % mean of prior on cluster means
b_0 = ?;  % scalar which relates the covariance of the prior
		  % on the mean to the covariance of the data.
a_0 = ?;  % scalar parameter used as all dirichlet prior parameters for pi
nu_0 = ?; % degrees of freedom of wishart prior on covariance matrices
W_0 = ?;  % covariance matrix parameter of wishart prior on covariance matrices

lb = [];
lower_bound = -Inf;
do = 1;

while do
    [alpha,m,W,nu,beta] = get_other_parameters(r, meas);
    r = get_r(alpha,m,W,nu,beta,meas);
    
    lower_bound_update = variational_lower_bound(r,alpha,m,W,nu,beta,meas);
    do = (lower_bound_update - lower_bound) > .001;
    lower_bound = lower_bound_update;
    lb = [lb lower_bound];
    
    figure(3)
    plot(lb);
    
    figure(2)
    [mx grp] = max(r,[],2);
    plot_d_dimensional_mixture_data(meas,grp)
end

disp(['expected rand index is = ' num2str(expected_rand_index(meas,r,group))])

mean_number_clusters = 0;

for i = 1 : 1000
    z_sample = simulate_z(r);
    mean_number_clusters = mean_number_clusters + size(unique(z_sample),1);
end

disp(['mean number of clusters in posterior distribution is = ' num2str(mean_number_clusters / 1000)])






