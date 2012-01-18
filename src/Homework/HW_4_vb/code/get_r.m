function r = get_r(alpha,m,W,nu, beta,X)
% This function calculates a matrix r which are parameters of the
% distribution over assignments for each row of the data matrix X.  The
% upated r is based on the values alpha, m, W, nu, and beta.
%
%@param alpha       : k x 1 matrix of positive dirichlet parameters
%@param m           : d x k matrix of means
%@param W           : k long cell array of d x d covariance matrics 
%@param nu          : k x 1 matrix of degrees of freedom for W matrices
%@param beta        : k x 1 matrix of scaling factors for NIW distributions
%@param X           : n x d data matrix
%
%@return r          : n x k matrix for distribution of z_i