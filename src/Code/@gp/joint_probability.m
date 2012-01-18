function [lp p lp2 lp3 lp4] = joint_probability(gp,kernel_params,a_0,b_0,a_1,b_1,a_w,b_w)
% GP/JOINT_PROBABILITY Computes the joint marginal probability of the
% targets t conditioned on the inputs
%
% p(t|x) = \int p(t|y,x)p(y)dy = N(t|0,C)

% Copyright October, 2006, Brown University, Providence, RI.
% All Rights Reserved

% Permission to use, copy, modify, and distribute this software and its
% documentation for any purpose other than its incorporation into a commercial
% product is hereby granted without fee, provided that the above copyright
% notice appear in all copies and that both that copyright notice and this
% permission notice appear in supporting documentation, and that the name of
% Brown University not be used in advertising or publicity pertaining to
% distribution of the software without specific, written prior permission.

% BROWN UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
% INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY
% PARTICULAR PURPOSE. IN NO EVENT SHALL BROWN UNIVERSITY BE LIABLE FOR ANY
% SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
% CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
% CONNECTION WITH THE USE.

% Author: Frank Wood fwood@cs.brown.edu


if nargin < 2
    a_0 = 1;
    b_0 = 1;
    a_1 = 1;
    b_1 = 1;
    a_w = ones(size(gp.input(:,1)));
    b_w = ones(size(a_w));
end




if nargin == 1
    y=gp.output(:,1:gp.current_size);

    md2 = y*gp.Cinv(1:gp.current_size,1:gp.current_size)*y';

    logZ = (-gp.current_size/2)*log(2*pi)- (1/2)* logdet(gp.C(1:gp.current_size,1:gp.current_size));
    lp = -md2 +logZ;
else

    temp_gp = set(gp,'kernel_params',kernel_params);
    
    y=temp_gp.output(:,1:temp_gp.current_size);

    md2 = -y*temp_gp.Cinv(1:temp_gp.current_size,1:temp_gp.current_size)*y';
    lp3 = md2;
    lp2 = - (1/2)* logdet(temp_gp.C(1:temp_gp.current_size,1:temp_gp.current_size));
    logZ = (-gp.current_size/2)*log(2*pi);

    lp = md2 +lp2+logZ;
    
    v_0 = kernel_params(1);
    v_1 = kernel_params(2);
    w = kernel_params(3:end);
    lp4 = a_0 * log(b_0) - gammaln(a_0) + (a_0 -1)*log(v_0) -b_0 * v_0 ...
        + a_1 * log(b_1) - gammaln(a_1) + (a_1 -1)*log(v_1) -b_1 * v_1 ...
        + sum(-log(sqrt(2*pi)*b_w*w)- (1/(2*(b_w^2)))*(log(w)-a_w).^2);
    lp = lp4 + lp;
    %     error('two argument version not yet implemented')

    %     p = mvnpdf(t,zeros(size(t)),inv(gp.Cinv));
end
p = exp(lp);
