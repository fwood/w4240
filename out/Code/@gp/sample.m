function y = sample(gp,x)
% GP/SAMPLE  Sample GP function over x values (dim x # datapoints)

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

% if nargin == 1
%     x = linspace(-1,1,100);
% end


[mu sigma] = predict(gp,x);

y = randn(size(x)).*((sigma).^(1/2))+mu;
% 
% K = zeros(size(x,2));
% 
% for i = 1:size(x,2)
%     eval(['kv = ' gp.kernel '(x, x(:,i), 1:size(x,2),' ...
%                               'inf, gp.kernel_params);']);
% 
%     K(:,i) = kv;
%     K(i,:) = kv;
% end
%     
% y = mvnrnd(zeros(1,size(x,2)),K);