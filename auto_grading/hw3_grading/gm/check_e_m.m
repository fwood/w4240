function [m_diff,dim_p,p_diff,cell_indicater,s_diff,d1,d2,g_diff] = check_e_m(data,data1,gamma)

[m,s,p] = m_step_gaussian_mixture(data,gamma);
[m2,s2,p2] = m_step(data,gamma);

m_diff = (m - m2).^2;
dim_p = size(p,1);
p_diff = (p(:) - p2).^2;

d1 = det(s{1});
d2 = det(s{1});

[m3,s3,p3] = m_step_gaussian_mixture(data1,gamma);
g = e_step_gaussian_mixture(data1,p3,m3,s3);
[m4,s4,p4] = m_step(data1,gamma);
g2 = e_step_unbiased(data1,p4,m4,s4);

cell_indicater = 0;
for i = 1 : length(s4)
    if iscell(s3)
        s_diff_temp = (s3{i} - s4{i}).^2;
    else
        s_diff_temp = (s3(:,:,i) - s4{i}).^2;
        cell_indicater = 1;
    end
          
    s_diff = sum(s_diff_temp(:));
end

g_diff = (g - g2).^2;

end

