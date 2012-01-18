function [d ss] = rbf(x_i, x_h, i, h, params )
% function d = rbf_kernel(x_i, x_h, i, h, params)
% params = [v_0 v_1 w]
% computes the covariance function between x_1 and x_2 given parameters
% v_0, v_1, w
%
%  d = v_0 * exp(-1/2 \sum_{j=1}{D} (x_i(j)  - x_h(j))^2/w(j)^2) +
%      I(i==h)v_1
%
% if w is a scalar 
%
%  d = v_0 * exp(-1/2 \sum_{j=1}{D} (x_i(j)  - x_h(j))^2/w^2) +
%      I(i==h)v_1
v_0 = params(1);
v_1 = params(2);
w = params(3:end);

if length(w) == 1 && size(x_i,1)>1
    w = repmat(w,size(x_i,1),1);
end

if size(x_i,1) > 1
    ss = (x_i - repmat(x_h,1,size(x_i,2))).^2./repmat((w.^2),1,size(x_i,2));
    d = v_0 * exp(-0.5 * sum(ss)) + (i==h)*v_1;
else
        ss = (x_i - repmat(x_h,1,size(x_i,2))).^2;
        d = v_0 * exp(-0.5 * ss./repmat((w.^2),1,size(x_i,2))) + (i==h)*v_1;
end