% this is a demonstration of the variational approximation to a 2D gaussian
% highlighted in PRML Chapter 10, page 467.  a 2d gaussian is approximated 
% by the product of two one dimensional gaussians through standard 
% variational updates (10.13, 10.15)




%% set up distribution to be approximated (2D gaussian)

%use the same random number sequence for debugging purposes
RandStream.setDefaultStream ...
     (RandStream('mt19937ar','seed',2));

mu = [5 5]';
Lambda = wishrnd(eye(2),2);
Lambda_inv = inv(Lambda);

plotMVNIsosurfaces(mu, Lambda_inv,'g');
view([0 90])

%% set up variational approximation (10.12 -> 10.15)
% set up variational approximation parameters

m_1 = 10; 
m_2 = 10;
S_1 = 5;
S_2 = 5;

mu_1 = mu(1);
mu_2 = mu(2);
lambda_11 = Lambda(1,1);
lambda_12 = Lambda(1,2);
lambda_22 = Lambda(2,2);

% set up variational approximation loop

% repeat until convergence
for loop = 1:10

    plotMVNIsosurfaces(mu, Lambda_inv,'g');
    hold on
    plotMVNIsosurfaces([m_1 m_2]', [1/lambda_11 0; 0 1/lambda_22],'r');
    view([0 90])
    hold off
    
    drawnow
    pause(1)
    
    % compute variational updates
    m_1 = mu_1 - (1/lambda_11)*lambda_12*(m_2-mu_2);
    m_2 = mu_2 - (1/lambda_22)*lambda_12*(m_1-mu_1);
    
end