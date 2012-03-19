% This main file is used to execute the em algorithm for gaussian mixture
% modeling.  The data is the fisher iris data where each row of data are
% four measurements taken from the pedal of an iris flower.  The value is e
% is a small number to asses convergence of the algorithm.  Whent the
% likelihood of the data under the model ceases to increase by e every time
% the algorithm is assumed to have converged.  Important variables are
% listed below.
%
% data  : data matrix n x d with rows as elements of data
% gamma : a n x k matrix of responsilities.  each row should sum to 1.
% pi    : column vector of probabilities for each class
% param :  mu   : d x k matrix of class centers listed as columns
% sigma : k x 1 cell array of class covariance matrices (each are d x d)

%clear 

% k is the number of clusters to use, you should experiment with this
% number and MAKE SURE YOUR CODE WORKS FOR ANY VALUE OF K >= 1
%k = 25;
e = .01;

format short g;
t1 = fix(clock);
start_min = t1(5);
disp(['The start time is: ' num2str(t1(4)) ':' num2str(t1(5)) ':' num2str(t1(6))]);

load fisheriris

data = meas;
clear species meas

% this sets the initial values of the gamma matrix, the matrix of
% responsibilities, randomly based on independent draws from a dirichlet
% distribution.
%gamma = gamrnd(ones(size(data,1),k),1); 
%gamma = gamma ./ repmat(sum(gamma,2),1,k);

%save('gamma_test','gamma');
%load gamma


% to facilitate visualization, we label each data point by the cluster
% which takes most responsibility for it.
[m labels] = max(gamma,[],2);

% this draws a plot of the initial labeling.
clf
figure(1)
plot_data(data,labels)

% given the initial labeling we set mu, sigma, and pi based on the m step
% and calculate the likelihood.
ll = -inf;
[mu,sigma,pi] = m_step_gaussian_mixture(data,gamma);
nll = log_likelihood_gaussian_mixture(data,mu,sigma,pi);
disp(['the log likelihood = ' num2str(nll);])

% the loop iterates until convergence as determined by e.
while ll + e < nll
    ll = nll;
    gamma = e_step_gaussian_mixture(data,pi,mu,sigma);
    [mu,sigma,pi] = m_step_gaussian_mixture(data,gamma);
    nll = log_likelihood_gaussian_mixture(data,mu,sigma,pi);
    disp(['the log likelihood = ' num2str(nll)]);
    
    now = fix(clock);
    if (start_min <= now(5) - 4)
        break;
    end
    
    [m labels] = max(gamma,[],2);
    figure(2)
    plot_data(data,labels);
end
t2 = fix(clock);
disp(['The end time is: ' num2str(t2(4)) ':' num2str(t2(5)) ':' num2str(t2(6))]);
disp(['The run time is: ' num2str(etime(t2, t1)) 's']);