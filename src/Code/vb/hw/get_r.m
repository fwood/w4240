function r = get_r(alpha,m,W,nu, beta,X)
%@param alpha       : k x 1 matrix of positive dirichlet parameters
%@param m           : d x k matrix or means, with means in cols
%@param W           : k long cell array of d x d covariance matrics 
%@param nu          : k x 1 matrix of degrees of freedom for W matrices
%@param beta        : k x 1 matrix of scaling factors for NIW distributions
%@param X           : n x d data matrix
%
%@return r          : n x k matrix with distribution of z_i in row i
