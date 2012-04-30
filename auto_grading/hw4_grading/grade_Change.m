Whether_First_Time_Run_This_Program = 1;
Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW=0;

ids = dir('../hw4/'); ids2 = struct2cell(ids); ids3 = ids2(:); ids4 = ids3(1:5:size(ids3,1));
ids5 = ids4(3:size(ids4,1)); ids6 = ids5(1:(size(ids5)-Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW),1);
uni_list = ids6(:);

% cdToStudent = ['cd ~/Documents/ta/w4240/hw/hw4/' uni];
% cdToMe = 'cd ~/Documents/np_bayes/shared/web/w4240/src/Code/vb/solution/';
% cdHome = 'cd ~/Documents/ta/w4240/hw/hw4_grading';
% 
% eval(cdHome);
% copyfile('plot_d_dimensional_mixture_data.m',['../hw4/' uni]);

if Whether_First_Time_Run_This_Program == 1
    fid = fopen('Grade.csv','a');
    fprintf(fid,'Uni,grade');
    fclose(fid);
end

for i = 1 : size(uni_list,1)
    clc;
    clear;

    Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW = 0;
    restoredefaultpath;
    % Generate a uni list from file 'hw4' again, since everything would be 
    % cleared during the loop.
    ids = dir('../hw4/');
    ids2 = struct2cell(ids);
    ids3 = ids2(:);
    ids4 = ids3(1:5:size(ids3,1));
    ids5 = ids4(3:size(ids4,1));
    ids6 = ids5(1:(size(ids5)-Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW),1);
    uni_list = ids6(:);
    
    fid=fopen('Grade.csv', 'rt');
    title = textscan(fid, '%s %s',1,'delimiter', ',');
    C = textscan(fid, '%s %d32','delimiter', ',');
    fclose(fid);
    students_done = C{1};
    uni_list = setdiff(uni_list, students_done);
    disp(uni_list)
    
    uni = uni_list{1};
    copyfile('plot_d_dimensional_mixture_data.m',['../hw4/' uni]);
    
    grade = 100;
    
    global m_0 b_0 a_0 W_0 nu_0;

    load fisheriris
    
    group(1:50,1) = 1;
    group(51:100,1) = 2;
    group(101:150,1) = 3;
    
    [N D]  = size(meas);
    K = 15;
    load mu;
    cd Solution/
    [my_new_centers my_assignments] = update_cluster_centers(mu,meas);
    p = ['../../hw4/' uni '/'];
    cd (p)
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

    cd ../../hw4_grading
    load r_init
    cd Solution/
    [my_alpha,my_m,my_W,my_nu,my_beta] = get_other_parameters(r, meas);

    p = ['../../hw4/' uni '/'];
    cd (p)
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

	cd ../../hw4_grading/Solution/
    my_r = get_r(my_alpha,my_m,my_W,my_nu,my_beta,meas);
    p = ['../../hw4/' uni '/'];
    cd (p)
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


	cd ../../hw4_grading/Solution/
    my_expected_rand_index = expected_rand_index(meas,my_r,group);
    p = ['../../hw4/' uni '/'];
    cd (p)
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
    
    cd ../../hw4_grading/
    fid = fopen('Grade.csv','a');
    fprintf(fid,['\n' uni ',' num2str(grade) ',' ]);
    fclose(fid);
end








