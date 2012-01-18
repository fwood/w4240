function ret_gp = remove(arg_gp,input, output)
% GP/REMOVE  Remove a single input / output data pair (dim x # datapoints) to the
% GP

% Copyright October, 2007, Brown University, Providence, RI. 
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

hits = arg_gp.output(:,1:arg_gp.current_size) == output;

D = size(arg_gp.input,1);
d = 1;
while sum(hits)>1 && d <= D
    hits = hits & (arg_gp.input(d,1:arg_gp.current_size) == input(d,1));
    d = d+1;
end

rind = min(find(hits==1));
hits = zeros(size(hits));
hits(rind) = 1;
% cheap and terrible hack
% ret1_gp = gp(arg_gp.input(:,~hits),arg_gp.output(:,~hits),arg_gp.kernel,arg_gp.kernel_params,arg_gp.capacity,D);
% 
% 

Ctmp = arg_gp.C(~hits,~hits);
M = arg_gp.Cinv(~hits,~hits);
m = arg_gp.Cinv(~hits,rind);
mu = arg_gp.Cinv(rind,rind);
Cinvtmp = M - 1/mu * m*m';

ret_gp = arg_gp;
ret_gp.C(1:arg_gp.current_size-1,1:arg_gp.current_size-1) = Ctmp;
ret_gp.C(arg_gp.current_size,:)= 0;
ret_gp.C(arg_gp.current_size,end)= 0;
ret_gp.Cinv(1:arg_gp.current_size-1,1:arg_gp.current_size-1) = Cinvtmp;
ret_gp.Cinv(arg_gp.current_size,:)= 0;
ret_gp.Cinv(:,arg_gp.current_size)= 0;
ret_gp.input(:,1:arg_gp.current_size-1) = arg_gp.input(:,~hits);
ret_gp.input(:,arg_gp.current_size) = 0; 
ret_gp.output(:,1:arg_gp.current_size-1) = arg_gp.output(:,~hits);
ret_gp.output(:,arg_gp.current_size) = 0;
ret_gp.current_size = arg_gp.current_size-1;
ret_gp.diff_squares(arg_gp.current_size,:,:) = 0;
ret_gp.diff_squares(:,arg_gp.current_size,:) = 0;
ret_gp.diff_squares(1:arg_gp.current_size-1,1:arg_gp.current_size-1,:) = arg_gp.diff_squares(~hits,~hits,:);

% % if gp.current_size-1 == 0
% %     mu = 1/kappa;
% %     gp.Cinv(1,1) = mu;
% %     gp.C(1,1) = kappa;
% %     gp.diff_squares(1,1,:) = ss(end,:);
% % else
% %     mu = (kappa - k'*gp.Cinv(1:gp.current_size-1,1:gp.current_size-1)*k)^-1;
% %     m = -mu*gp.Cinv(1:gp.current_size-1,1:gp.current_size-1)*k;
% %     M = gp.Cinv(1:gp.current_size-1,1:gp.current_size-1) + (1/mu)* m*m';
% % %     gp.Cinv = [M m; m' mu];  % could preallocate these as well which would help speed up the class considerably
% %     gp.Cinv(1:gp.current_size-1,1:gp.current_size-1) = M;
% %     gp.Cinv(gp.current_size-1+1,1:gp.current_size-1) = m;
% %     gp.Cinv(1:gp.current_size-1,gp.current_size-1+1) = m';
% %     gp.Cinv(gp.current_size-1+1,gp.current_size-1+1) = mu;
% % %     gp.C = [gp.C k; k' kappa]; % same
% %     gp.C(gp.current_size-1+1,1:gp.current_size-1) = k;
% %     gp.C(1:gp.current_size-1,gp.current_size-1+1) = k';
% %     gp.C(gp.current_size-1+1,gp.current_size-1+1) = kappa;
% % 
% %     % this is really just for the rbf kernel 
% %     gp.diff_squares(gp.current_size-1+1,1:gp.current_size-1,:) = ss(:,1:end-1)';
% %     gp.diff_squares(1:gp.current_size-1,gp.current_size-1+1,:) = ss(:,1:end-1)';
% %     gp.diff_squares(gp.current_size-1+1,gp.current_size-1+1,:) = ss(:,end);
% % end
% % 
% % gp.current_size = gp.current_size - 1;
% 
