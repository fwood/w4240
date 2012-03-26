function check_e_m_Nick(data,gamma)

[m,s,p] = m_step_gaussian_mixture(data,gamma);
[m2,s2,p2] = m_step(data,gamma);

m_diff = (m - m2).^2;
disp(['m_diff sum = ' num2str(sum(m_diff(:)))]);

if size(p,1) == 1
    disp('!!! p wrong dim !!!')
end
       
p_diff = (p(:) - p2).^2;
disp(['p_diff sum = ' num2str(sum(p_diff(:)))]);

for i = 1 : length(s2)
    if iscell(s)
        s_diff = (s{i} - s2{i}).^2;
    else
        s_diff = (s(:,:,i) - s2{i}).^2;
        disp('did not use cell array')
    end
          
    disp(['s_diff sum = ' num2str(sum(s_diff(:)))]);
end

g = e_step_gaussian_mixture(data,p,m,s);
g2 = e_step(data,p,m,s2);

g_diff = (g - g2).^2;
disp(['g_diff sum = ' num2str(sum(g_diff(:)))]);

ll = log_likelihood_gaussian_mixture(data,m,s,p);
ll2 = log_likelihood(data,m,s2,p);

disp(['ll_diff sum = ' num2str((ll - ll2)^2)]);
