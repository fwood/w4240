function [alpha,m,W,nu,beta] = get_other_parameters(r, X)
% This function calculated the updated parameter values for alpha, m, W, 
% nu, and beta given the value of r and the data matrix X.
%
%@param r           : n x k matrix for distribution of z_i
%@param X           : n x d data matrix
%
%@return alpha       : k x 1 matrix of positive dirichlet parameters
%@return m           : d x k matrix of means
%@return W           : k long cell array of d x d covariance matrics 
%@return nu          : k x 1 matrix of degrees of freedom for W matrices
%@return beta        : k x 1 matrix of scaling factors for NIW distributions

global m_0 b_0 a_0 W_0 nu_0