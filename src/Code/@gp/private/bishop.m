function [d ss] = bishop(x_i, x_h, i, h, params )
% function d = bishop(x_i, x_h, i, h, params)
% params = [v_0 v_1 w]
% computes the covariance function between x_1 and x_2 given parameters
% theta_0, theta_1, theta_2, theta_3, beta (not beta^-1)
%
%  theta_0 * exp(-(theta_1/2) * (x_i - repmat(x_h,1,size(x_i,2))).^2) +
%  repmat(theta_2,1,size(x_i,2))+ theta_3*x_i*x_h + (i==h)*(1/beta)
%

theta_0 = params(1);
theta_1 = params(2);
theta_2 = params(3);
theta_3 = params(4);
beta = params(5);

if size(x_i,1) > 1
    error('bishop > 1D not implemented yet')
%     d = v_0 * exp(-0.5 * sum((x_i - repmat(x_h,1,size(x_i,2))).^2./repmat((w.^2),1,size(x_i,2)))) + (i==h)*v_1;
else
            ss = (x_i - repmat(x_h,1,size(x_i,2))).^2;
        d = theta_0 * exp(-(theta_1/2) * (x_i - repmat(x_h,1,size(x_i,2))).^2) + repmat(theta_2,1,size(x_i,2))+ theta_3*x_i*x_h + (i==h)*(1/beta);
end

