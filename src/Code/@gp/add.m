function gp = add(gp,input, output)
% GP/ADD  Add a single input / output data pair (dim x # datapoints) to the
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

if isempty(input) || isempty(output)
    warning('Dr. Wood kindly requests that you give input and output');
    return;
end

if gp.current_size == 0 && gp.capacity == 0
    gp.capacity = gp.capacity+10;
    
    gp.Cinv = zeros(gp.capacity,gp.capacity);
    gp.C = zeros(gp.capacity,gp.capacity);
    gp.diff_squares = zeros(gp.capacity,gp.capacity,size(input,1));
    gp.input = zeros(size(input,1),gp.capacity);
    gp.output = zeros(size(output,1),gp.capacity);
end

if gp.current_size == gp.capacity 
    % grow the GP
    gp.capacity = gp.capacity+10;
    
    temp = gp.Cinv;
    gp.Cinv = zeros(gp.capacity,gp.capacity);
    gp.Cinv(1:gp.current_size,1:gp.current_size) = temp;
    temp = gp.C;
    gp.C = zeros(gp.capacity,gp.capacity);
    gp.C(1:gp.current_size,1:gp.current_size) = temp;
    temp = gp.diff_squares;
    gp.diff_squares = zeros(gp.capacity,gp.capacity,size(input,1));
    gp.diff_squares(1:gp.current_size,1:gp.current_size,:) = temp;
    temp = gp.input;
    gp.input = zeros(size(input,1),gp.capacity);
    gp.input(:,1:gp.current_size) = temp;
    temp = gp.output;
    gp.output = zeros(size(output,1),gp.capacity);
    gp.output(:,1:gp.current_size) = temp;
end


gp.current_size = gp.current_size + 1;
gp.input(:,gp.current_size) = input;
gp.output(:,gp.current_size) = output;


eval(['[kkappa ss]= ' gp.kernel '(gp.input(:,1:gp.current_size), input, 1:gp.current_size,' ...
                              'gp.current_size, gp.kernel_params);']);
k = kkappa(1:end-1)';
kappa = kkappa(end);
if gp.current_size-1 == 0
    mu = 1/kappa;
    gp.Cinv(1,1) = mu;
    gp.C(1,1) = kappa;
    gp.diff_squares(1,1,:) = ss(end,:);
else
    mu = (kappa - k'*gp.Cinv(1:gp.current_size-1,1:gp.current_size-1)*k)^-1;
    m = -mu*gp.Cinv(1:gp.current_size-1,1:gp.current_size-1)*k;
    M = gp.Cinv(1:gp.current_size-1,1:gp.current_size-1) + (1/mu)* m*m';
%     gp.Cinv = [M m; m' mu];  % could preallocate these as well which would help speed up the class considerably
    gp.Cinv(1:gp.current_size-1,1:gp.current_size-1) = M;
    gp.Cinv(gp.current_size-1+1,1:gp.current_size-1) = m;
    gp.Cinv(1:gp.current_size-1,gp.current_size-1+1) = m';
    gp.Cinv(gp.current_size-1+1,gp.current_size-1+1) = mu;
%     gp.C = [gp.C k; k' kappa]; % same
    gp.C(gp.current_size-1+1,1:gp.current_size-1) = k;
    gp.C(1:gp.current_size-1,gp.current_size-1+1) = k';
    gp.C(gp.current_size-1+1,gp.current_size-1+1) = kappa;

    % this is really just for the rbf kernel 
    gp.diff_squares(gp.current_size-1+1,1:gp.current_size-1,:) = ss(:,1:end-1)';
    gp.diff_squares(1:gp.current_size-1,gp.current_size-1+1,:) = ss(:,1:end-1)';
    gp.diff_squares(gp.current_size-1+1,gp.current_size-1+1,:) = ss(:,end);
end


