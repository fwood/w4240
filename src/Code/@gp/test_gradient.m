function [dz dz2 dz3 dz4] = test_gradient(gp,kernel_params,a_0,b_0,a_1,b_1,a_w,b_w)
% GP/PARTIAL Computes the gradient of the rbf gaussian process log joint with a gamma, gamma, lognormal prior
%
% d/dz p(t|x,z)p(z)

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

if nargin < 3
    a_0 = 1;
    b_0 = 1;
    a_1 = 1;
    b_1 = 1;
    a_w = ones(size(gp.input(:,1)));
    b_w = ones(size(a_w));
end

dz = zeros(size(gp.kernel_params));
dz2 = zeros(size(gp.kernel_params));
dz3 = zeros(size(gp.kernel_params));
dz4 = zeros(size(gp.kernel_params));
run = 10e-8;

for i = 1:length(dz)
    [lp1 p lp2 lp3 lp7]= joint_probability(gp,kernel_params,a_0,b_0,a_1,b_1,a_w,b_w);
    kp = kernel_params;
    kp(i) = kp(i)+run;
    [lp4 p lp5 lp6 lp8]= joint_probability(gp,kp,a_0,b_0,a_1,b_1,a_w,b_w);
    dz(i) = (lp4-lp1)/run;
    dz2(i) = (lp5-lp2)/run;
    dz3(i) = (lp6-lp3)/run;
        dz4(i) = (lp8-lp7)/run;
end
