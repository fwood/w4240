function [m_diff,dim_p,p_diff,cell_indicater,s_diff,d1,d2,g_diff] = check_e_m(data,data1,gamma)
m = 0;s = 0;p = 0;m2 = 0;s2 = 0;p2 = 0;mm = 0;s_diff = 0;ss = 0;a = 0;a2 = 0;b = 0;b2 = 0;aa = 0;bb = 0;
m_diff = 0;dim_p = 0; p_diff = 0; cell_indicater=0; d1 = 0;d2 = 0;g_diff = 0;

[m,s,p] = m_step_gaussian_mixture(data,gamma);
[m2,s2,p2] = m_step(data,gamma);

cell_indicater = 0;
for i = 1 : length(s2)
    if iscell(s)
        s_diff_temp = (s{i} - s2{i}).^2;
    else
        s_diff_temp = (s(:,:,i) - s2{i}).^2;
        cell_indicater = 1;
    end
          
    s_diff = sum(s_diff_temp(:));
end

m_diff = (m - m2).^2;
dim_p = size(p,1);
p_diff = (p(:) - p2).^2;

d1 = det(s{1});
d2 = det(s{1});

[m3,s3,p3] = m_step(data1,gamma);
g = e_step_gaussian_mixture(data1,p3,m3,s3);
g2 = e_step_unbiased(data1,p3,m3,s3);

g_diff = (g - g2).^2;

end

