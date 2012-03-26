%function check_e_m(X, Y)
alpha = .5;
beta = .5;

[m s] = e_step_linear_regression(X, Y, alpha, beta);

[m2 s2] = e_step(X,Y,alpha,beta);

mm = sum((m - m2).^2);
disp(['m diff = ' num2str(mm)])

s_diff = (s - s2).^2;
ss = sum(s_diff(:));
disp(['s diff = ' num2str(ss)])

[a b] = m_step_linear_regression(X,Y,m,s);
[a2 b2] = m_step(X,Y,m,s);

aa = (a - a2)^2;
disp(['a diff = ' num2str(aa)]);
bb = (b - b2)^2;
disp(['b diff = ' num2str(bb)]);
