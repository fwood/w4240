function [ret_gp] = hmcmc_sample(old_gp, a_0, b_0, a_1, b_1, a_w, b_w, num_samples, num_leaps, max_epsilon)
% GP/HMCMC_SAMPLE  
%
% [ret_gp] = hmcmc_sample(gp, a_0, b_0, a_1, b_1, a_w, b_w)
%
% Uses hybrid Monte Carlo to sample new hyperparameters for an rbf GP with
% gamma, gamma, prod log normal prior

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

if nargin < 10
    max_epsilon = .01;
end


if nargin < 8
    num_samples = 1;
    num_leaps = 20;
end

if nargin < 2
    a_0 = 10e-10;
    b_0 = 10e-10;
    a_1 = 10e-10;
    b_1 = 10e-10;
    a_w = ones(size(old_gp.input(:,1)));
    b_w = ones(size(a_w));
end

num_samples = num_samples+1;

Z = zeros(num_samples,3);
% lps = zeros(num_samples,1);

% num_samples = 100;
Z(1,:) = old_gp.kernel_params; %[80.1008 152.3897 3.7359];%[10 20 2]; %
% num_leaps = 20;
% epsilon = .1;

% old_gp = gp(input,output,'rbf',Z(1,:),size(input,2));
Eq = -joint_probability(old_gp,Z(1,:),a_0, b_0, a_1, b_1, a_w, b_w);
% lps(1) = -Eq;
oldlp = -Eq;

for s = 2:num_samples
    epsilon = rand*max_epsilon;
    z = Z(s-1,:);
    r = randn(size(z));
    Kp = .5*sum(r.^2);

    Eq = -oldlp;

    Hqp = Eq + Kp;
    direction = round(rand)*2-1;
    epsilon  = epsilon*direction;

    temp_gp = old_gp;
    for t = 1:num_leaps
        r_half = r + epsilon/2 .* gradient(temp_gp,z, a_0, b_0, a_1, b_1, a_w, b_w);
        z = z + epsilon.*r_half;
        % can we make the GP update more efficient?  I think so...
        temp_gp = gp(old_gp.input(:,1:old_gp.current_size),old_gp.output(:,1:old_gp.current_size),'rbf',z,size(old_gp.input,2),size(old_gp.input,1));
        r = r_half + epsilon/2 .* gradient(temp_gp,z+epsilon, a_0, b_0, a_1, b_1, a_w, b_w);
        if ~isreal(r) || ~isreal(z) || min(z)<0
%             warning('Bad momentum or position in hmcmc -- step size probably too large');
            Eqstar = Inf;
            Kpstar = Inf;
            break;
        end
    end

    if min(z)<0
        Z(s,:) = Z(s-1,:);
        continue;
    else
        Eqstar = -joint_probability(temp_gp);
    end
    Kpstar = .5*sum(r.^2);
    if ~isreal(Eqstar) || isnan(real(Eqstar)) || ~isreal(Kpstar) || isnan(real(Kpstar)) 
%         warning('Non-real or NaN energy in hmcmc sampler')
%         Eqstar = Inf;
%         Kpstar = Inf;
        Z(s,:) = Z(s-1,:);
        continue;
    end
    

    Hqpstar = Eqstar + Kpstar;

%     disp(['Hqp = ' num2str(Hqp) ', Hqpstar = ' num2str(Hqpstar)]);
    
    if min(exp(-(Hqpstar-Hqp)),1) > rand
        
%         disp(['accept ' mat2str(z)])
        oldlp = -Eqstar;
        Z(s,:) = z;
        old_gp = temp_gp;
%         lps(s) = -Eqstar;
        
    else
%                 disp(['reject ' mat2str(z)])
%         disp('reject')
%         lps(s) = oldlp;
        Z(s,:) = Z(s-1,:);
        
    end
end

ret_gp = old_gp;