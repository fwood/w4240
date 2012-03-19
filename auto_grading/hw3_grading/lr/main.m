% This main file sets up the steps of fitting a linear regression with an
% independent normal prior, centered at zero, on the weight parametes.  The 
% hyper parameters of the model are then beta, the precision of the noise
% , and alpha, the precisionn on the weights.  The problem is to find
% maximum likelihood estimators of alpha and beta with the weight
% parameters integrated out.  Variables of interested are listed here :
%
% d : covariate dimension of data
% X : design (covariate) matrix, with intercept column included
% Y : vector of observations
% w : vector of true weigts used for simulation of data
%
% alpha : weight precision (scalar)
% beta  : observation noise precision (scalar)
% m     : mean of weight distribtion in e_step (16 x 1)
% s     : covariance of weight distribution in e_step (16 x 16)
% ll    : approximate log likelihood of the joint distribution

%d = 199;
%d = 15
e = 0.00001;
%load data_linear_regression
%load data_test

format short g;
t1 = fix(clock);
start_min = t1(5);
disp(['The start time is: ' num2str(t1(4)) ':' num2str(t1(5)) ':' num2str(t1(6))]);

% randomly set alpha, beta, and m to start
alpha = gamrnd(1,1);
beta = gamrnd(1,1);
m = unifrnd(-1,1,d + 1,1);

% iterate until convergence
ll = log_likelihood(X,Y,m,beta);
disp(['log likelihood = ' num2str(ll) ', alpha = ' num2str(alpha) ', beta = ' num2str(beta)]);


while (true)
    [m s] = e_step_linear_regression(X,Y,alpha,beta);
    [alpha beta] = m_step_linear_regression(X,Y,m,s);

    if (ll + e >= log_likelihood(X,Y,m,beta)) 
        break;
    end
    
    now = fix(clock);
    if (start_min <= now(5) - 4)
        break;
    end
    
    ll = log_likelihood(X,Y,m,beta);
    disp(['log likelihood = ' num2str(ll) ', alpha = ' num2str(alpha) ', beta = ' num2str(beta)]);
end
t2 = fix(clock);
disp(['The end time is: ' num2str(t2(4)) ':' num2str(t2(5)) ':' num2str(t2(6))]);
disp(['The run time is: ' num2str(etime(t2, t1)) 's']);