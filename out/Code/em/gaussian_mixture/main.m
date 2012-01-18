k = 30;
d = 20;
n = 10000;
[data labels] = generate_data(n,d,k);

clf
figure(1)
plot_data(data,labels)

%%

[mu sigma pi] = k_means(k,data);

ll = log_likelihood(data,mu,sigma,pi);
disp(['the log likelihood = ' num2str(ll);])
nll = ll + 1;
for i = 1 : 25
    ll = nll;
    gamma = e_step(data,pi,mu,sigma);
    [mu,sigma,pi] = m_step(data,gamma);
    nll = log_likelihood(data,mu,sigma,pi);
    disp(['the log likelihood = ' num2str(nll)]);
    
    [m l] = max(gamma,[],2);
    figure(2)
    plot_data(data,l);
end