function check_e_m(X, Y)
alpha = .5;
beta = .5;

[m s] = e_step_linear_regression(X, Y, alpha, beta);

[m2 s2] = e_step(X,Y,alpha,beta);

disp(['m diff = ' num2str(sum((m - m2).^2))])

s_diff = (s - s2).^2;

disp(['s diff = ' num2str(sum(s_diff(:)))])

[a b] = m_step_linear_regression(X,Y,m,s);
[a2 b2] = m_step(X,Y,m,s);

disp(['a diff = ' num2str((a - a2)^2)]);

disp(['b diff = ' num2str((b - b2)^2)]);
