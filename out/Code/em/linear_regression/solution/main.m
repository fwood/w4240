d = 500;
alpha = 2; %weight precision
beta = 10; %data precision

n = 10000;

[X Y w] = generate_data(n,d,beta,alpha);

alpha = gamrnd(1,1);
beta = gamrnd(1,1);
m = unifrnd(-1,1,d+1,1);

ll = log_likelihood(X,Y,m,beta);
disp(['log likelihood = ' num2str(ll) ', alpha = ' num2str(alpha) ', beta = ' num2str(beta)]);
for i = 1:10
    [m s] = e_step(X,Y,alpha,beta);
    [alpha beta] = m_step(X,Y,m,s);
    ll = log_likelihood(X,Y,m,beta);
    disp(['log likelihood = ' num2str(ll) ', alpha = ' num2str(alpha) ', beta = ' num2str(beta)]);
end