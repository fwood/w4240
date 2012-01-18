function [data labels] = sample_from_prior(K,d)


global m_0 b_0 a_0 W_0 nu_0
W = cell(K,1);
m = zeros(d,K);

for k = 1 : K
    W{k} = wishrnd(W_0,nu_0);
    m(:,k) = mvnrnd(m_0,inv(b_0 * W{k}));
end
pi = gamrnd(a_0,1,k,1);
pi = pi / sum(pi);

n = 100;

data = zeros(n,d);
labels = zeros(n,1);
for i = 1 : n
    z = randsample(1:K,1,true,pi);
    data(i,:) = mvnrnd(m(:,z),inv(W{k}));
    labels(i) = z;
end



