function [mu sigma] = predict(gp,input)
% GP/PREDICT  Output prediction distribution (mu is the mean of this distribution,
%             sigma the variance
% GP

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

    mu = zeros(1,size(input,2));
    sigma = zeros(1,size(input,2));
    for i=1:size(input,2)
        eval(['kkappa = ' gp.kernel '(input(:,i), input(:,i), 1,' ...
            '1, gp.kernel_params);']);

        sigma(i) = kkappa;
    end
else
    mu = zeros(1,size(input,2));
    sigma = zeros(1,size(input,2));
    for i=1:size(input,2)
        eval(['kkappa = ' gp.kernel '([gp.input(:,1:gp.current_size) input(:,i)], input(:,i), 1:gp.current_size+1,' ...
            'gp.current_size+1, gp.kernel_params);']);
        k = kkappa(1:end-1)';
        c = kkappa(end);

        mu(i) = k'*(gp.Cinv(1:gp.current_size,1:gp.current_size)*gp.output(1:gp.current_size)');
        sigma(i) = c - k'*gp.Cinv(1:gp.current_size,1:gp.current_size)*k;
    end
end

