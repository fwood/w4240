%hyper parameters
D = 4;
hyper_params.beta_0 = 1;
hyper_params.m_0 = zeros(1,D);
hyper_params.W_0_inv = inv(eye(D,D));
hyper_params.nu_0 = D;
hyper_params.alpha_0 = 1;


n = 150;

[samples labels means covariances] =  sample_igmm_prior(n,hyper_params.alpha_0,1,hyper_params.m_0,hyper_params.W_0_inv,1/hyper_params.beta_0,hyper_params.nu_0)
scatter(samples(:,1),samples(:,2),[],labels);