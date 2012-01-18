% introduction to Bayes example matlab -- 

%% set some parameters and examine prior
% beta distribution params for prior belief factory defect rate
alpha = 5;
beta = 5;

% plot prior probability of pencil defect
theta = linspace(0,1,50);
figure(1)
plot(theta,betapdf(theta,alpha,beta))
xlabel('\Theta')
ylabel('P(\Theta)')
legend(['Beta(' num2str(alpha) ',' num2str(beta) ')'])
title('\Theta = pencil defect rate')

%% generate from generative model
% i.e., what would draws from such a prior over factories look like

num_coins = 1000000;
coin_thetas = betarnd(alpha,beta,num_coins,1);

figure(2)
hist(coin_thetas,100)


%% do some posterior computation(s)

outcomes = {'defective', 'good'};

% observe data with hidden parameter (unobserved)
flips = generate_example_data();

% count the number of observations we got from the factory
num_flips = length(flips);

% use the prior defined in the section above
prior_params = [alpha beta];

% initialize a count of the number of heads/defects
num_heads = 0;

% initialize a plot for the posterior probability
% with no observations the posterior is simply the prior
figure(3)
plot(theta,betapdf(theta,prior_params(1), prior_params(2)))
pause % pause for keyboard input

% look through observations and update posterior dist over theta given each
% observation
for n =1:num_flips
    % display the measured outcome
    disp(['Pencil defective or not : ' outcomes{flips(n)+1}]);
    
    % observe outcome
    nth_outcome = flips(n);
    
    % heads/defect is 0
    if nth_outcome == 0
        num_heads = num_heads + 1;
    end
       
    % update posterior (beta / binomial cojugacy used here)
    posterior_params = [num_heads + prior_params(1), n-num_heads + prior_params(2)];
    
    % plot the observations so that we can visualize defects vs. no defects
    figure(2)
    plot_flips(flips,n)
    
    % plot the prior (fixed in red) and the posterior (variable in green) 
    figure(3)
    prior_h = plot(theta,betapdf(theta,prior_params(1), prior_params(2)),'r');
    hold on % overlay the second plot
    post_h = plot(theta,betapdf(theta,posterior_params(1), posterior_params(2)),'g');
    hold off
    legend([prior_h post_h], 'Prior', ['Posterior after ' num2str(n) ' obs.']);
     xlabel('Defective=0 , Non-defective=1')
     ylabel('P(\Theta)')
     
     % compute posterior intervals
     lower_lim = betainv(.05,posterior_params(1),posterior_params(2));
    upper_lim = betainv(.95,posterior_params(1),posterior_params(2));
    
    % draw intervals on plots
    line([lower_lim lower_lim],[0 max(betapdf(theta,posterior_params(1), posterior_params(2)))]);
    line([upper_lim upper_lim],[0 max(betapdf(theta,posterior_params(1), posterior_params(2)))]);
    drawnow
    
    % plot the posterior predictve distribution of a defect on the n+1^th
    % observation
    figure(4) % posterior predictive figure
    predicted_outcome = 0;
    log_p_heads = gammaln(prior_params(1)+prior_params(2)+n) - gammaln(num_heads + prior_params(1)) - gammaln(n-num_heads + prior_params(2)) + ...
        gammaln(num_heads + prior_params(1) + (1-predicted_outcome)) + gammaln(n+1 -num_heads -(1-predicted_outcome)+ prior_params(2)) - gammaln(prior_params(1)+ prior_params(2)+n+1);
    predicted_outcome = 1;
    log_p_tails = gammaln(prior_params(1)+prior_params(2)+n) - gammaln(num_heads + prior_params(1)) - gammaln(n-num_heads + prior_params(2)) + ...
        gammaln(num_heads + prior_params(1) + (1-predicted_outcome)) + gammaln(n+1 -num_heads -(1-predicted_outcome)+ prior_params(2)) - gammaln(prior_params(1)+ prior_params(2)+n+1);
    
    bar([0 1], exp([log_p_heads log_p_tails]));
    xlabel('Defective=0 , Non-defective=1')
    ylabel('Posterior predictive probability');
    
    % for the first ten loops, pause for user input
    if n<10
        pause
    end
end

%% now that we have the posterior let's ask some questions like -- what's
% the probability that theta is below .15

%something like the 95% confidence interval -- here taking into account
% the prior

lower_lim = betainv(.05,posterior_params(1),posterior_params(2))
upper_lim = betainv(.95,posterior_params(1),posterior_params(2))