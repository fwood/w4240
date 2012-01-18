function [rlp mu sigma k kappa] = lp(gp,input,output, k)
% GP/LP  
%
% [rlp mu sigma k] = lp(gp,input,output, k)
%
% Output probability of input / output pair under the Gaussian
% process, rlp is the log probability and mu, sigma is the mean and
% variance of the Gaussian distribution over outputs for the given input

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


if gp.current_size == 0

      eval(['sigma = ' gp.kernel '(input,input,1,1,gp.kernel_params);']);
    
        mu = 0;
    %    rlp = 1/(sqrt(2*pi)*sigma)*exp(-(1/(2*(sigma^2)))*(output^2));
    rlp = -log(sqrt(2*pi))-log(sigma)-(1/(2*(sigma^2)))*(output^2);
    k = [];
    kappa = sigma;
    
else
    if nargin < 4
        eval(['k = ' gp.kernel '([gp.input(:,1:gp.current_size) input],input,1:gp.current_size+1,gp.current_size+1,gp.kernel_params);']);
    end
         kappa = k(end);
         k = k(1:end-1);
         mu = k*gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)';
         sigma = kappa - k*gp.Cinv(1:gp.current_size,1:gp.current_size)*k';
         if sigma < 0
             warning(['GP predictive variance is negative, sigma=' num2str(sigma) ' setting it to zero. Possible indication of something very bad going on but if sigma is really small it''s probably ok'])
         	sigma = 0;
         end
         rlp = -.5 * (1/sigma^2) * (output - mu)^2 - log(sigma) -log(sqrt(2*pi)); % skipping constants here
    
end

