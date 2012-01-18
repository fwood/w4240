function lb = variational_lower_bound(r,alpha,m,W,nu,beta,X)
% This function calculates the variational lower bound.  This value should
% go up as the algorithm progresses.  The algorithm only stops when the
% variational lower bound has stopped increasing.
%
%@param r           : n x k matrix for distribution of z_i
%@param alpha       : k x 1 matrix of positive dirichlet parameters
%@param m           : d x k matrix of means
%@param W           : k long cell array of d x d covariance matrics 
%@param nu          : k x 1 matrix of degrees of freedom for W matrices
%@param beta        : k x 1 matrix of scaling factors for NIW distributions
%@param X           : n x d data matrix
%
%@return lb         : calculated scalar lower bound

global m_0 b_0 a_0 W_0 nu_0


