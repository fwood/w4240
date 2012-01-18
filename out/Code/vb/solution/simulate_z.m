function z_sample = simulate_z(r)
% This function simulates Z values from the optimized Q distribution.
% Since the Z_i are independent, all we need is the r matrix and we can
% sample each Z_i independently from the multinomial distribution in the
% i'th row of r.
%
%@param r   : n x k matrix with rows = distribution for z_i
%
%@return z  : n x 1 sample of cluster allocations for each data point

[N K] = size(r);

z_sample = zeros(N,1);

rand_var = unifrnd(0,1,N,1);
cuSum = r(:,1);
z_sample(z_sample == 0 & cuSum > rand_var) = 1;
for k = 2 : K
    cuSum = cuSum + r(:,k);
    z_sample(z_sample == 0 & cuSum > rand_var) = k;
end