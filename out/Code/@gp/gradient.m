function [dz ] = gradient(gp,kernel_params,a_0,b_0,a_1,b_1,a_w,b_w)
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

v_0 = kernel_params(1);
v_1 = kernel_params(2);
w = kernel_params(3:end);

tv = gp.C(1:gp.current_size,1:gp.current_size) -...
     eye(gp.current_size,gp.current_size)*v_1;

% diffs_squared = zeros(gp.current_size,gp.current_size);
%     for j = 1:gp.current_size
%         for k = 1:gp.current_size
%             diffs_squared(j,k) = sum((gp.input(:,j)-gp.input(:,k)).^2./(w.^2));
%         end
%     end


    
dCdv_0 = tv/v_0;
dCdv_1 = eye(gp.current_size,gp.current_size);


dv_0 = (a_0-1)/v_0-b_0-...
    .5*trace(gp.Cinv(1:gp.current_size,1:gp.current_size) * dCdv_0) +...
    .5*gp.output(1:gp.current_size)*gp.Cinv(1:gp.current_size,1:gp.current_size)*...
    dCdv_0*gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)';
dv_1 = (a_1-1)/v_1-b_1-...
    .5*trace(gp.Cinv(1:gp.current_size,1:gp.current_size) * dCdv_1) +...
    .5*gp.output(1:gp.current_size)*gp.Cinv(1:gp.current_size,1:gp.current_size)*...
    dCdv_1*gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)';

% dv_02 = -.5*trace(gp.Cinv(1:gp.current_size,1:gp.current_size) * dCdv_0);
% dv_03 = gp.output(1:gp.current_size)*gp.Cinv(1:gp.current_size,1:gp.current_size)*...
%     dCdv_0*gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)';
% dv_04 = (a_0-1)/v_0-b_0;
% dv_12 = -.5*trace(gp.Cinv(1:gp.current_size,1:gp.current_size) * dCdv_1);
% dv_13 = gp.output(1:gp.current_size)*gp.Cinv(1:gp.current_size,1:gp.current_size)*...
%     dCdv_1*gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)';
% 
% dv_14 = (a_1-1)/v_1-b_1;
dw = zeros(size(w));
% dw2 = zeros(size(w));
% dw3 = zeros(size(w));
% dw4 = zeros(size(w));
% diffs_squared = zeros(gp.current_size,gp.current_size);

for i = 1:length(w)
%     for j = 1:gp.current_size
%         for k = 1:gp.current_size
%             diffs_squared(j,k) = (gp.input(i,j)-gp.input(i,k))^2;
%         end
%     end
    dCdwi = tv.*(( gp.diff_squares(1:gp.current_size,1:gp.current_size,i)./(w(i)^3)));  %w may need to to be repmatted 
    dw(i) = -1/w(i)-(1/((b_w.^2)*w(i)))*(log(w(i))-a_w)-.5*trace(gp.Cinv(1:gp.current_size,1:gp.current_size) * dCdwi) +.5*gp.output(1:gp.current_size)*gp.Cinv(1:gp.current_size,1:gp.current_size)*dCdwi*gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)';
%     dw2(i) = -.5*trace(gp.Cinv(1:gp.current_size,1:gp.current_size) * dCdwi);
%     dw3(i) = gp.output(1:gp.current_size)*gp.Cinv(1:gp.current_size,1:gp.current_size)*dCdwi*gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)';
%     dw4(i) = -1/w(i)-(1/((b_w^2)*w(i)))*(log(w(i))-a_w);
end

dz = [dv_0 dv_1 dw];
% dz2 = [dv_02 dv_12 dw2];
% dz3 = [dv_03 dv_13 dw3];
% dz4 = [dv_04 dv_14 dw4];