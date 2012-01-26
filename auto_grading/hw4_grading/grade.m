clc
clear
uni = 'mjg2152';

cdToStudent = ['cd ~/Documents/ta/w4240/hw/hw4/' uni];
cdToMe = 'cd ~/Documents/np_bayes/shared/web/w4240/src/Code/vb/solution/';
cdHome = 'cd ~/Documents/ta/w4240/hw/hw4_grading';

eval(cdHome);
copyfile('plot_d_dimensional_mixture_data.m',['../hw4/' uni]);

grade = 100;

global m_0 b_0 a_0 W_0 nu_0;

load fisheriris

group(1:50,1) = 1;
group(51:100,1) = 2;
group(101:150,1) = 3;

[N D]  = size(meas);
K = 15;

eval(cdHome);
load mu;

eval(cdToMe);
[my_new_centers my_assignments] = update_cluster_centers(mu,meas);
eval(cdToStudent);
rightCount = 0;
try
    [new_centers assignments] = update_cluster_centers(mu,meas);
    d = abs(my_new_centers - new_centers);
    
    if max(d(:)) > .01
        disp('new cluster centers too much')
        disp(max(d(:)))
    else
        rightCount = rightCount + 1;
    end
    
    d = abs(my_assignments - assignments);
    if max(d(:)) > .01
        disp('assignments not correct')
    else
        rightCount = rightCount + 1;
    end
    
catch e
    disp('update cluster centers does not work')
end
grade = grade - 3 * (2 - rightCount);

m_0 = zeros(D,1);
b_0 = 1;
a_0 = 1;
nu_0 = 4;
W_0 = 10 * eye(4) / nu_0;

eval(cdHome)
load r_init

eval(cdToMe);
[my_alpha,my_m,my_W,my_nu,my_beta] = get_other_parameters(r, meas);
eval(cdToStudent)
rightCount = 0;
try
    [alpha,m,W,nu,beta] = get_other_parameters(r, meas);
    
    try
        d = abs(my_alpha - alpha);
    catch
        disp('alpha error')
    end
    
    if max(d(:)) > 0.01
        disp('alpha diff too much');
        disp(max(d(:)))
    else
        rightCount = rightCount + 1;
    end
    
    try
        d = abs(my_m(:) - m(:));
    catch
        disp('m error');
    end
    
    if max(d(:)) > 0.01
        disp('m diff too much');
        disp(max(d(:)))
    else
        rightCount = rightCount + 1;
    end
    
    try
        for i = 1:15
            d(i) = max(max(abs(my_W{i} - W{i})));
        end
    catch e
        disp('W error')
    end
    
    if max(d(:)) > 0.01
        disp('W diff too much');
        disp(max(d(:)))
    else
        rightCount = rightCount + 1;
    end
    
    try
    d = abs(my_nu - nu);
    catch
        disp('nu error')
    end
    if max(d(:)) > 0.01
        disp('nu diff too much');
        disp(max(d(:)))
    else
        rightCount = rightCount + 1;
    end
    
    try
    d = abs(my_beta - beta);
    catch
        disp('beta error')
    end
    if max(d(:)) > 0.01
        disp('beta diff too much');
        disp(max(d(:)))
    else
        rightCount = rightCount + 1;
    end
catch e
    disp('broke in get other parameters')
    disp(e)
end
grade = grade - (5 - rightCount) * 3;

eval(cdToMe);
my_r = get_r(my_alpha,my_m,my_W,my_nu,my_beta,meas);
eval(cdToStudent)
try
    r = get_r(my_alpha,my_m,my_W,my_nu,my_beta,meas);
    
    try
        d = abs(my_r - r);
    catch
        disp('r_diff broke it')
    end
        
    if max(d(:)) > .05
        grade = grade - 10;
        disp('r diff')
        disp(max(d(:)))
    end
catch
    grade = grade - 10;
    disp('broke during get r');
end


eval(cdToMe);
my_expected_rand_index = expected_rand_index(meas,my_r,group);
eval(cdToStudent)
try
    expected_rand_index = expected_rand_index(meas,my_r,group);
    
    d = min(abs(my_expected_rand_index - expected_rand_index), abs(my_expected_rand_index - (1 -expected_rand_index)));
    if d > 0.01
        grade = grade - 10;
        disp('expected rand index diff')
        disp(d);

    end
catch
    disp('broke in expected rand index')
    grade = grade - 10;
end

grade






