%function check_e_m(X, Y)
alpha = .5;beta = .5;
m = 0;m2 = 0;s = 0;s2 = 0;mm = 0;s_diff = 0;ss = 0;a = 0;a2 = 0;b = 0;b2 = 0;aa = 0;bb = 0;

[m s] = e_step_linear_regression(X, Y, alpha, beta);

[m2 s2] = e_step(X,Y,alpha,beta);

mm = sum((m - m2).^2);
disp(['m diff = ' num2str(mm)])

s_diff = (s - s2).^2;
ss = sum(s_diff(:));
disp(['s diff = ' num2str(ss)])

[a b] = m_step_linear_regression(X,Y,m2,s2);
[a2 b2] = m_step(X,Y,m2,s2);

aa = (a - a2)^2;
disp(['a diff = ' num2str(aa)]);
bb = (b - b2)^2;
disp(['b diff = ' num2str(bb)]);
