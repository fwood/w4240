function [alpha,m,W,nu,beta] = get_other_parameters(r, X)
% Gets all parameters in the variational updates other than the r matrix
%
%@param r           : n x k matrix for distribution of z_i
%@param X           : n x d data matrix
%
%@return alpha       : k x 1 matrix of positive dirichlet parameters
%@return m           : d x k matrix of means, with means in cols
%@return W           : k long cell array of d x d covariance matrics 
%@return nu          : k x 1 matrix of degrees of freedom for W matrices
%@return beta        : k x 1 matrix of scaling factors for NIW distributions

global m_0 b_0 a_0 W_0 nu_0