%% create training data
reset(RandStream.getDefaultStream);

N = 20;
x = linspace(0,10,N)' + rand(N,1)
Phi = [ones(N,1) x x.^2 x.^3];
w = [3 0 .2 -.003]';
beta = .3;
y = Phi * w + randn(N,1)*sqrt(1/beta);

%plot training data -- note, 
figure(1)
scatter(x,y)
xlabel('Input')
ylabel('Output')

%% set up prior parameters for bayesian regression model

% gamma prior for weight vector regularization
a_0 = 1;
b_0 = .1; 
% gamma prior for observation noise variance
a_1 = 1;
b_1 = 1;

figure(2)
xx = linspace(0,10,100);
h0 = plot(xx,gampdf(xx,a_0,1/b_0),'r');
hold on
h1 = plot(xx,gampdf(xx,a_1,1/b_1),'g');
hold off
legend([h0 h1],'weight vector prior','observation noise prior')

%% do variational inference for Bayesian linear regression
converged = 0;
xxx = linspace(0,10,100);
xx = linspace(0,10,100)';
Phixx = [ones(100,1) xx xx.^2 xx.^3];
loop = 0;

% some precomputation
[N,M] = size(x); 
K = Phi'*Phi; % K for Kernal matrix
yty = y'*y;
ytPhi = y'* Phi;

% initial expectations
E_alpha = a_0 * b_0;
E_beta = a_1 * b_1;

while ~converged
S_n = pinv(E_beta * K + E_alpha * eye(M,M));
m_n = S_n * (Phi')*y * E_beta;

a_1_n = N/2 + a_1;
b_1_n = (1/2) * (yty - 2*ytPhi*m_n + trace(K*S_n) + m_n'*K*m_n) + b_1;

a_0_n = M/2 + a_0;
b_0_n = (1/2) * (trace(S_n) + m_n'*m_n) + b_0;

E_alpha = a_0_n * b_0_n;
E_beta = a_1_n * b_1_n;

figure(1)
scatter(x,y)
xlabel('Input')
ylabel('Output')
hold on
plot(xx,Phixx*m_n,'r');
hold off
loop = loop +1;
disp(num2str(loop));

figure(3)
h0 = plot(xxx,gampdf(xxx,a_0_n,1/b_0_n),'r');
hold on
h1 = plot(xxx,gampdf(xxx,a_1_n,1/b_1_n),'g');
hold off
legend([h0 h1],'weight vector posterior','observation noise posterior')
pause

end
