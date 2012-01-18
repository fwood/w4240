function lb = variational_lower_bound(r,alpha,m,W,nu,beta,X)
%Calculates the lower bound on the negative KL divergence between the true
%poseterior distribution and the variational posterior
%
%@param r           : n x k matrix for distribution of z_i
%@param alpha       : k x 1 matrix of positive dirichlet parameters
%@param m           : d x k matrix
%@param W           : k long cell array of d x d covariance matrics 
%@param nu          : k x 1 matrix of degrees of freedom for W matrices
%@param beta        : k x 1 matrix of scaling factors for NIW distributions
%@param X           : n x d data matrix

global m_0 b_0 a_0 W_0 nu_0




