% This is an auto grading program for Data Mining HW4. You can use this program
% to generate a grade book for students' HW4 automatically.
% Before using this program, we need to do some preparation first:
% 1. Download student's HW, and then put them into a file named by students'
% uni. Do it for every student.
% 2. Put all these files in a file named by 'hw4'.
% 3. Please make sure that you have a file called 'hw4_grading', which contains
% the grading program 'grade_Change' and file 'Solution'.
% 4. Please delete 'Grade.csv' in file 'hw4_grading' if ther are there 
% for the first time you use this program.
% 5. Please generate a file called 'hw', and then put the file 'hw4' and 'hw4_grading'
% into this file 'hw'.
% 6. Now we've finished almost every preparation. Please make sure that every time 
% before you run this program, check whether you assign the right value to 
% the variable called 'Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW' 
% and 'Whether_First_Time_Run_This_Program' in line 21, line 33 and line 61.

% Please count how many files are not given by students in the file 'hw3'
% and change the following variable. You should also change the value of
% this variable in line 61.
Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW=0;
% Please make sure whether this is your first time run this program to
% grade HW3. In many cases you may want to or have to close this program
% even it is running. In this case, you can just close this program and 
% reopen it any time later, just change the following variable's value to 0
% when you run this program again. And then you should also make sure 
% whether there is any student's score is not completed in file 
% 'BeforeGrading.csv'. If some student's score are not completed in file 
% 'BeforeGrading.csv', delete that row in the csv file, and then run this 
% program again you would get complete scores. Of course, if it is 
% your first time use this program, please make sure the following 
% variable's value is 1.
Whether_First_Time_Run_This_Program = 1;


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
    fprintf(fid,'Uni,grade,');
    fprintf(fid,'new cluster centers too much,assignments not correct,update cluster centers does not work,');
    fprintf(fid,'alpha error,alpha diff too much,m error,m diff too much,W error,W diff too much,nu error,nu diff too much,beta error,beta diff too much,broke in get other parameters,');
    fprintf(fid,'r_diff broke it,r diff,broke during get r,');
    fprintf(fid,'expected rand index diff,broke in expected rand index');
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
    title = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter', ',');
    C = textscan(fid, '%s %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32','delimiter', ',');
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
    new_cluster_centers_too_much = 0;
    assignments_not_correct = 0;
    update_cluster_centers_does_not_work = 0;
    
    try
        [new_centers assignments] = update_cluster_centers(mu,meas);
        d = abs(my_new_centers - new_centers);
    
        if max(d(:)) > .01
            disp('new cluster centers too much')
            new_cluster_centers_too_much = 1;
            disp(max(d(:)))
        else
            rightCount = rightCount + 1;
        end
    
        d = abs(my_assignments - assignments);
        if max(d(:)) > .01
            disp('assignments not correct')
            assignments_not_correct = 1;
        else
            rightCount = rightCount + 1;
        end
    
        catch e
        disp('update cluster centers does not work')
        update_cluster_centers_does_not_work = 1;
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
    alpha_error = 0;
    alpha_diff_too_much = 0;
    m_error = 0;
    m_diff_too_much = 0;
    W_error = 0;
    W_diff_too_much = 0;
    nu_error = 0;
    nu_diff_too_much = 0;
    beta_error = 0;
    beta_diff_too_much = 0;
    broke_in_get_other_parameters = 0;

    try
        [alpha,m,W,nu,beta] = get_other_parameters(r, meas);
    
        try
            d = abs(my_alpha - alpha);
        catch
            disp('alpha error')
            alpha_error = 1;
        end
    
        if max(d(:)) > 0.01
            disp('alpha diff too much');
            alpha_diff_too_much = 1;
            disp(max(d(:)))
        else
            rightCount = rightCount + 1;
        end
    
        try
            d = abs(my_m(:) - m(:));
        catch
            disp('m error');
            m_error = 1;
        end
    
        if max(d(:)) > 0.01
            disp('m diff too much');
            m_diff_too_much = 1;
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
            W_error = 1;
        end
    
        if max(d(:)) > 0.01
            disp('W diff too much');
            W_diff_too_much = 1;
            disp(max(d(:)))
        else
            rightCount = rightCount + 1;
        end
    
        try
            d = abs(my_nu - nu);
        catch
            disp('nu error')
            nu_error = 1;
        end
        if max(d(:)) > 0.01
            disp('nu diff too much');
            nu_diff_too_much = 1;
            disp(max(d(:)))
        else
            rightCount = rightCount + 1;
        end
    
        try
            d = abs(my_beta - beta);
        catch
            disp('beta error')
            beta_error = 1;
        end
        if max(d(:)) > 0.01
            disp('beta diff too much');
            beta_diff_too_much = 1;
            disp(max(d(:)))
        else
            rightCount = rightCount + 1;
        end
    catch e
        disp('broke in get other parameters')
        broke_in_get_other_parameters = 1;
        disp(e)
    end
    grade = grade - (5 - rightCount) * 3;

	cd ../../hw4_grading/Solution/
    my_r = get_r(my_alpha,my_m,my_W,my_nu,my_beta,meas);
    p = ['../../hw4/' uni '/'];
    cd (p)
    r_diff_broke_it = 0;
    r_diff = 0;
    broke_during_get_r = 0;
    
    try
        r = get_r(my_alpha,my_m,my_W,my_nu,my_beta,meas);
    
        try
            d = abs(my_r - r);
        catch
            disp('r_diff broke it')
            r_diff_broke_it = 1;
        end
        
        if max(d(:)) > .05
            grade = grade - 10;
            disp('r diff')
            r_diff = 1;
            disp(max(d(:)))
        end
    catch
        grade = grade - 10;
        disp('broke during get r');
        broke_during_get_r = 1;
    end


	cd ../../hw4_grading/Solution/
    my_expected_rand_index = expected_rand_index(meas,my_r,group);
    p = ['../../hw4/' uni '/'];
    cd (p)
    expected_rand_index_diff = 0;
    broke_in_expected_rand_index = 0;
    try
        expected_rand_index = expected_rand_index(meas,my_r,group);
    
        d = min(abs(my_expected_rand_index - expected_rand_index), abs(my_expected_rand_index - (1 -expected_rand_index)));
        if d > 0.01
            grade = grade - 10;
            disp('expected rand index diff')
            expected_rand_index_diff = 1;
            disp(d);

        end
    catch
        disp('broke in expected rand index')
        broke_in_expected_rand_index = 1;
        grade = grade - 10;
    end
    
    cd ../../hw4_grading/
    fid = fopen('Grade.csv','a');
    fprintf(fid,['\n' uni ',' num2str(grade) ',' ]);
    if new_cluster_centers_too_much == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if assignments_not_correct == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if update_cluster_centers_does_not_work == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if alpha_error == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if alpha_diff_too_much == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if m_error == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if m_diff_too_much == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if W_error == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if W_diff_too_much == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if nu_error == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if nu_diff_too_much == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if beta_error == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if beta_diff_too_much == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if broke_in_get_other_parameters == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if r_diff_broke_it == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if r_diff == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if broke_during_get_r == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if expected_rand_index_diff == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    if broke_in_expected_rand_index == 1
        fprintf(fid,[num2str(1) ',' ]);
    else
        fprintf(fid,[num2str(0) ',' ]);
    end
    fclose(fid);
    end




   



