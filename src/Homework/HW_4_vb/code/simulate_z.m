function z_sample = simulate_z(r)
% This function simulates Z values from the optimized Q distribution.
% Since the Z_i are independent, all we need is the r matrix and we can
% sample each Z_i independently from the multinomial distribution in the
% i'th row of r.
%
%@param r   : n x k matrix with rows = distribution for z_i
%
%@return z  : n x 1 sample of cluster allocations for each data point
