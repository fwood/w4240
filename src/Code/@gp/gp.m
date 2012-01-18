function d = gp(input, output, kernel, kernel_params, capacity, input_dim)
%GP Gaussian process class constructor.
%   d = gp(input, output, kernel, kernel_params, capacity, input_dim) 
%         creates a Gaussian process from input and output data 
%         with kernel (currently only the default, 'rbf' is supported) and
%         with kernel parameters kernel_params ([v_0 v_1 w]) 
%         and initial capacity given by capacity -- more points can be 
%         added after the fact and the capacity will automatically grow.
%         input_dim must be supplied only if creating an empty GP
%
%   gp can also be called with a single argument
%   like d = GP(p) where p is a Gaussian process process to be copied, two
%   arguments in which case the default kernel is 'rbf' and the default
%   kernel parameters are [1 1 1].   The default capacity is 300.

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
if nargin>=2 && (isempty(input)||isempty(output)) &&~exist('input_dim','var')
    error('GP constructor must have input/output or dimension');
end

if nargin < 6
    input_dim = size(input,1);
end

d.capacity = 300;
d.Cinv = zeros(d.capacity,d.capacity);
d.C = zeros(d.capacity,d.capacity);
d.diff_squares = zeros(d.capacity,d.capacity,input_dim);
d.input = zeros(input_dim,d.capacity);
d.output = zeros(1,d.capacity);

d.kernel = 'rbf';
d.kernel_params = [1 1 1];
d.current_size = 0;



if nargin == 0
    d = class(d,'gp');
elseif nargin == 1
    if(isa(input,'gp'))
        d.Cinv = input.Cinv;
        d.C = input.C;
        d.kernel = input.kernel;
        d.kernel_params = input.kernel_params;
        d.capacity = input.capacity;
        d.diff_squares = input.diff_squares;
        d.input = input.input;
        d.output = input.output;
        d.current_size = input.current_size;
        d = class(d,'gp');
    elseif isa(input,'struct')
        disp('Trying to create a GP from a struct');
        d.capacity=input.capacity;
        d.Cinv=input.Cinv;
        d.C = input.C;
        d.kernel = input.kernel;
        d.kernel_params = input.kernel_params;
        d.capacity = input.capacity;
        d.diff_squares = input.diff_squares;
        d.input = input.input;
        d.output = input.output;
        d.current_size = input.current_size;
        d = class(d,'gp');
    else
        error('Single argument of wrong type -- not a GP')
    end
elseif nargin == 2
        d = class(d,'gp');
        d = train(d,input, output);
elseif nargin == 3
        error('If a kernel is specified, kernel hyperparameters must be specified as well')
elseif nargin == 4
        d.kernel = kernel;
        d.kernel_params = kernel_params;
        d = class(d,'gp');
        d = train(d,input, output);
elseif nargin == 5 || nargin == 6
        d.capacity = capacity;
        d.Cinv = zeros(d.capacity,d.capacity);
        d.C = zeros(d.capacity,d.capacity);

        if isempty(input) && nargin < 6
            error('Input dimension must be provided if no data is added immediately to GP');
        end
                d.diff_squares = zeros(d.capacity,d.capacity,input_dim);
        d.input = zeros(input_dim,d.capacity);
        d.output = zeros(1,d.capacity);

        d.kernel = kernel;
        d.kernel_params = kernel_params;
        d = class(d,'gp');
        d = train(d,input, output);
else
    error('Wrong number of arguments');
end
