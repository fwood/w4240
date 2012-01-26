% checking get_message_vn
cd ~/Documents/ta/w4240/hw/hw2_grading/
try
    m1 = get_message_vn(fn_bea,vn_a);
    m1 = m1 / sum(m1);
    m2 = get_message_vn(fn_bea, vn_b);
    m2 = m2 / sum(m2);
    m3 = get_message_vn(fn_aj, vn_j);
    m3 = m3 / sum(m3);
catch e
    m1 = ones(2,1);
    m2 = ones(2,1);
    m3 = ones(2,1);
end

cd ~/shared/web/w4240/src/Code/sum_product_algorithm/solution/explicit_algorithm/
get_m = @get_message_vn;

cd ~/Documents/ta/w4240/hw/hw2_grading/
m11 = get_m(fn_bea,vn_a);
m11 = m11 / sum(m11);
m22 = get_m(fn_bea, vn_b);
m22 = m22 / sum(m22);
m33 = get_m(fn_aj, vn_j);
m33 = m33 / sum(m33);


if (max(m1(:) - m11) > .001 || max(m2(:) - m22) > .001)
    disp('get message_vn is broken');
end

if (max(m3(:) - m33) > 0.001)
    disp('message from john is incorrect');
end

% checking get_message_fn_e
cd ~/Documents/ta/w4240/hw/hw2_grading/
try
    m1 = get_message_fn_e(vn_e);
    m1 = m1 / sum(m1);
catch e
    m1 = ones(2,1);
    m2 = ones(2,1);
    m3 = ones(2,1);
end

cd ~/shared/web/w4240/src/Code/sum_product_algorithm/solution/explicit_algorithm/
get_m = @get_message_fn_e;

cd ~/Documents/ta/w4240/hw/hw2_grading/
m11 = get_m(vn_e);
m11 = m11 / sum(m1);

if (max(m1 - m11) > 0.001)
    disp('get_message_fn_e is broken')
end

% checking get_message_fn_b
cd ~/Documents/ta/w4240/hw/hw2_grading/
try
    m1 = get_message_fn_b(vn_b);
    m1 = m1 / sum(m1);
catch e
    m1 = ones(2,1);
    m2 = ones(2,1);
    m3 = ones(2,1);
end

cd ~/shared/web/w4240/src/Code/sum_product_algorithm/solution/explicit_algorithm/
get_m = @get_message_fn_b;

cd ~/Documents/ta/w4240/hw/hw2_grading/
m11 = get_m(vn_b);
m11 = m11 / sum(m1);

if (max(m1 - m11) > 0.001)
    disp('get_message_fn_b is broken')
end

% checking get_message_fn_bea
cd ~/Documents/ta/w4240/hw/hw2_grading/
try
    m1 = get_message_fn_bea(vn_b);
    m1 = m1 / sum(m1);
    m2 = get_message_fn_bea(vn_e);
    m2 = m2 / sum(m2);
    m3 = get_message_fn_bea(vn_a);
    m3 = m3 / sum(m3);
catch e
    m1 = ones(2,1);
    m2 = ones(2,1);
    m3 = ones(2,1);
end

cd ~/shared/web/w4240/src/Code/sum_product_algorithm/solution/explicit_algorithm/
get_m = @get_message_fn_bea;

cd ~/Documents/ta/w4240/hw/hw2_grading/
m11 = get_m(vn_b);
m11 = m11 / sum(m11);
m22 = get_m(vn_e);
m22 = m22 / sum(m22);
m33 = get_m(vn_a);
m33 = m33 / sum(m33);

if (max(m1 - m11) > 0.001 || max(m2 - m22) > 0.001 || max(m3 - m33) > 0.001)
    disp('get_message_fn_bea is broken')
end

% checking get_message_aj
cd ~/Documents/ta/w4240/hw/hw2_grading/
try
    m1 = get_message_fn_aj(vn_a);
    m1 = m1 / sum(m1);
    m2 = get_message_fn_aj(vn_j);
    m2 = m2 / sum(m2);
catch e
    m1 = ones(2,1);
    m2 = ones(2,1);
    m3 = ones(2,1);
end

cd ~/shared/web/w4240/src/Code/sum_product_algorithm/solution/explicit_algorithm/
get_m = @get_message_fn_aj;

cd ~/Documents/ta/w4240/hw/hw2_grading/
m11 = get_m(vn_a);
m11 = m11 / sum(m11);
m22 = get_m(vn_j);
m22 = m22 / sum(m22);

if (max(m1 - m11) > 0.001 || max(m2 - m22) > 0.001)
    disp('get_message_fn_aj is broken')
end

% checking get_message_am
cd ~/Documents/ta/w4240/hw/hw2_grading/
try    
    m1 = get_message_fn_am(vn_a);
    m1 = m1 / sum(m1);
    m2 = get_message_fn_am(vn_m);
    m2 = m2 / sum(m2);
catch e
    m1 = ones(2,1);
    m2 = ones(2,1);
    m3 = ones(2,1);
end

cd ~/shared/web/w4240/src/Code/sum_product_algorithm/solution/explicit_algorithm/
get_m = @get_message_fn_am;

cd ~/Documents/ta/w4240/hw/hw2_grading/
m11 = get_m(vn_a);
m11 = m11 / sum(m11);
m22 = get_m(vn_m);
m22 = m22 / sum(m22);

if (max(m1 - m11) > 0.001 || max(m2 - m22) > 0.001)
    disp('get_message_fn_am is broken')
end


