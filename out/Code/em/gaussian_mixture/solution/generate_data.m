function [data labels mu sigma] = generate_data(n,d,k)
%generates d dimensional data with k components

pi = gamrnd(ones(1,k),ones(1,k));
pi = pi / sum(pi);
pi = .1 + .9*pi

mu = mvnrnd(zeros(k,d),eye(d));
sigma = cell(1,k);
for i = 1 : k
    sigma{i} = iwishrnd(eye(d),50);
end

data = zeros(n,d);
labels = zeros(n,1);
for i = 1 : n
    z = randsample(k,1,true,pi);
    labels(i) = z;
    data(i,:) = mvnrnd(mu(z,:),sigma{z});
end