function[h, beta, eta] = get_parameters()
% This function must be filled out to return the parameters used in the
% denoising script.
%
% return is [h, beta, eta]
%
% @return h     : parameter governing constant bias
% @return beta  : parameter governing correlation between neighboring x's
% @return eta   : parameter governing correlation between x_i and y_i

h = 0.2;
beta = 1;
eta = 1.5;