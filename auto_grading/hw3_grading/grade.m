% This is an auto grading program for Data Mining HW3. You can use this program
% to generate a grade book for students' HW3 automatically.
% Before using this program, we need to do some preparation first:
% 1. Download student's HW, and then put them into a file named by students'
% uni. Do it for every student.
% 2. Put all these files in a file named by 'hw3'.
% 3. Please make sure that you have a file called 'hw3_grading', which contains
% the grading program 'grade', file 'gm' and file 'lr'.
% 4. Please delete 'BeforeGrading.csv' and 'Grade.csv' in file 
% 'hw3_grading' if ther are there for the first time you use this program.
% 5. Please generate a file called 'hw', and then put the file 'hw3' and 'hw3_grading'
% into this file 'hw'.
% 6. Now we've finished almost every preparation. Please make sure that every time 
% before you run this program, check whether you assign the right value to 
% the variable called 'Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW' 
% and 'Whether_First_Time_Run_This_Program' in line 24, line 36 and line 57.


% Generate a uni list from file 'hw3'
clc;
% Please count how many files are not given by students in the file 'hw3'
% and change the following variable. You should also change the value of
% this variable in line 57.
Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW = 0;
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
Whether_First_Time_Run_This_Program = 0;

ids = dir('../hw3/'); ids2 = struct2cell(ids); ids3 = ids2(:); ids4 = ids3(1:5:size(ids3,1));
ids5 = ids4(3:size(ids4,1)); ids6 = ids5(1:(size(ids5)-Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW),1);
uni_list = ids6(:);

% Generate the title for the csv file 'BeforeGrading.csv'.
if Whether_First_Time_Run_This_Program == 1
    fid = fopen('BeforeGrading.csv','a');
    fprintf(fid,'Uni,');
    fprintf(fid,'crashed in LRbasic test,loglikehood wrong in LRbasic test,alpha wrong in LRbasic test,beta wrong in LRbasic test,run time over in LRbasic test,');
    fprintf(fid,'crashed in LRadvanced test,loglikehood wrong in LRadvanced test,alpha wrong in LRadvanced test,beta wrong in LRadvanced test,run time over in LRadvanced test,');
    fprintf(fid,'crashed in check regress,m wrong in check regress,s wrong in check regress,a wrong in check regress,b wrong in check regress,');
    fprintf(fid,'crashed in GMbaisc test,gamma wrong in GMbaisc test,loglikelihood wroing in GMbaisc test,run time over in GMbasic test,');
    fprintf(fid,'crashed in in check gm,mu wrong in check gm,p dim wrong in check gm,p wrong in check gm,not use cell erray,s wrong in check gm,g wrong in check gm,biased not added,');
    fprintf(fid,'crashed in GMadvanced test,loglikelihood wroing in GMadvanced test,run time over in GMadvanced test,');
    fclose(fid);
end

% The grading loop.
for i = 1 : size(uni_list,1)
    % Please don't forget to change this variable's value if necessary.
    Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW = 0;
    restoredefaultpath;
    % Generate a uni list from file 'hw3' again, since everything would be 
    % cleared during the loop.
    ids = dir('../hw3/');
    ids2 = struct2cell(ids);
    ids3 = ids2(:);
    ids4 = ids3(1:5:size(ids3,1));
    ids5 = ids4(3:size(ids4,1));
    ids6 = ids5(1:(size(ids5)-Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW),1);
    uni_list = ids6(:);
    
    % Read in information that already exists in 
    fid=fopen('BeforeGrading.csv', 'rt');
    title = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter', ',');
    C = textscan(fid, '%s %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32','delimiter', ',');
    fclose(fid);
    students_done = C{1};
    uni_list = setdiff(uni_list, students_done);
    disp(uni_list)

    % Make sure the path is all right.
    uni = uni_list{1};
    cd lr/
    p = ['../../hw3/' uni '/'];
    addpath(p);
    cd ..
    cd gm/
    addpath(p);
    cd ..
    
    % Write the uni in to the csv file 'BeforeGrading.csv'.
    fid = fopen('BeforeGrading.csv','a');
    fprintf(fid,['\n' uni_list{1} ',']);
    fclose(fid);

    % Linear regress answer
    %
    % log likelihood = -270.8895, alpha = 0.72357, beta = 9.7771
    %
    % second dataset
    %
    % log likelihood = -14094.0922, alpha = 10.1385, beta = 0.99904


    fprintf('\n \n')
	cd lr/
    try
        clear
        clear global
        d = 15;
        broke_indicater = 0;
        load data_linear_regression
        main
    catch e
        e.getReport()
        disp('broke in regular linear regress')
        broke_indicater = 1;
    end

    cd ..
    fid = fopen('BeforeGrading.csv','a');
    %Check whether the program crashed in the test. If crashed, write a "1" 
    %to the 'BeforeGrading.csv'.
    if (broke_indicater == 1)        
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    %Check whether the log likelihood is right in the test. If wrong, write
    %a "1" to the 'BeforeGrading.csv'.
    if ((abs(ll - (-270.8891)) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    %Check whether the alpha is right in the test. If wrong, write a "1" to
    %the 'BeforeGrading.csv'.
    if ((abs(alpha - 0.72357) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the beta is right in the test. If wrong, write a "1" to
    %the 'BeforeGrading.csv'.
    if ((abs(beta - 9.7776) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the run time is more than 4 min in the test. If more 
    %than 4', write a "1" to the 'BeforeGrading.csv'.
    if ((etime(t2, t1) > 230) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);
    
    
    fprintf('\n \n')
	cd lr/
    try
        clear
        clear global
        d = 199;
        broke_indicater = 0;
        load data_test
        main
    catch e
        e.getReport()
        disp('broke in test regress')
        broke_indicater = 1;
    end
    
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    %Check whether the program crashed in the test. If crashed, write a "1" 
    %to the 'BeforeGrading.csv'.
    if (broke_indicater == 1)
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the log likelihood is right in the test. If wrong, write
    %a "1" to the 'BeforeGrading.csv'.
    if ((abs(ll - (-14094.09)) > 1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    %Check whether the alpha is right in the test. If wrong, write a "1" to
    %the 'BeforeGrading.csv'.
    if ((abs(alpha - 10.1385) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the beta is right in the test. If wrong, write a "1" to
    %the 'BeforeGrading.csv'.
    if ((abs(beta - 0.99906) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the run time is more than 4 min in the test. If more 
    %than 4', write a "1" to the 'BeforeGrading.csv'.
    if ((etime(t2, t1) > 230) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);

    
    fprintf('\n \n')
	cd lr/
    try
        clear
        clear global
        broke_indicater = 0;
        load data_linear_regression
        check_e_m%(X,Y);
    catch e
        e.getReport()
        disp('broke in check regress')
        broke_indicater = 1;
    end
    
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    
	%Check whether the program crashed in the test. If crashed, write a "1" 
    %to the 'BeforeGrading.csv'.
    if (broke_indicater == 1)
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the difference of m is too big btw. student's code and
	%grader's code. If too big, write a "1" to the 'BeforeGrading.csv'.
    if ((sum((m - m2).^2) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the difference of s is too big btw. student's code and
	%grader's code. If too big, write a "1" to the 'BeforeGrading.csv'.
    if ((sum(s_diff(:)) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the difference of a is too big btw. student's code and
	%grader's code. If too big, write a "1" to the 'BeforeGrading.csv'.
    if (((a - a2)^2 > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the difference of b is too big btw. student's code and
	%grader's code. If too big, write a "1" to the 'BeforeGrading.csv'.
    if (((b - b2)^2 > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);


    % Gaussian mixture answer
    %
    % for regular, k = 2
    % the log likelihood = -212.3695
    %
    % for test k = 25
    % the log likelihood = -150.2529

    fprintf('\n \n')
    cd gm/
   
    try
        clear
        clear global
        broke_indicater = 0;
        load gamma
        load gamma_ans
        main
    catch e
        e.getReport()
        disp('broke in regular gm')
        broke_indicater = 1;
    end
    
	cd ..
    fid = fopen('BeforeGrading.csv','a');
	%Check whether the program crashed in the test. If crashed, write a "1" 
    %to the 'BeforeGrading.csv'.
    if (broke_indicater == 1)
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the gamma matrix is right. If wrong, write a "1" to the 
    %'BeforeGrading.csv'.
    g_diff = sum(gamma_ans - gamma);
	if (((abs(g_diff(1) - 0) > 5) && (abs(g_diff(1) - 150)>5)) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the loglikelihood is right. If wrong, write a "1" to the 
    %'BeforeGrading.csv'.
    if (ll ~= -Inf)
    	if ((abs(nll - ll) > error) || (broke_indicater == 1))
            fprintf(fid,[num2str(1) ',']);
        else
            fprintf(fid,[num2str(0) ',']);
        end
    else
        fprintf(fid,[num2str(1) ',']);
    end
	%Check whether the run time is too long. If too long, write a "1" to the 
    %'BeforeGrading.csv'.
	if ((etime(t2, t1) > 230) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);
    

	fprintf('\n \n')
    cd gm/
    
    try
        clear
        clear global
        m = 0;s = 0;p = 0;m2 = 0;s2 = 0;p2 = 0;mm = 0;s_diff = 0;ss = 0;a = 0;a2 = 0;b = 0;b2 = 0;aa = 0;bb = 0;
        m_diff = 0;dim_p = 0; p_diff = 0; cell_indicater=0; d1 = 0;d2 = 0;g_diff = 0;
        broke_indicater = 0;
        load gamma_10_2_test_e_m_step
        load data_10_4_test_e_step
        load data_10_4_test_m_step
        [m_diff,dim_p,p_diff,cell_indicater,s_diff,d1,d2,g_diff] = check_e_m(data,data1,gamma);
    catch e
        e.getReport()
        disp('broke in check gm')
        broke_indicater = 1;
    end
    
    cd ..
    fid = fopen('BeforeGrading.csv','a');
	%Check whether the program crashed in the test. If crashed, write a "1" 
    %to the 'BeforeGrading.csv'.
    if (broke_indicater == 1)
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	% Check whether m is calculated right. If wrong, write a '1' to the 
    % 'BeforeGrading.csv'.
    if ((sum(sum(m_diff.^2)) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	% Check whether the dimension of p is right. If wrong, write a '1' to the 
    % 'BeforeGrading.csv'.
    if ((dim_p == 1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	% Check whether p is calculated right. If wrong, write a '1' to the 
    % 'BeforeGrading.csv'.
    if ((sum(p_diff.^2) > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	% Check whether student use cell erray. If not, write a '1' to the 
    % 'BeforeGrading.csv'.
    if ((cell_indicater == 1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	% Check whether s is calculated right. If wrong, write a '1' to the 
    % 'BeforeGrading.csv'.
    if ((s_diff > 0.1) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	% Check whether g is calculated right. If wrong, write a '1' to the 
    % 'BeforeGrading.csv'.
    if (((sum(sum(g_diff)) > 0.1) || (broke_indicater == 1)))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	% Check whether student added biase to the sigma matrix or to the gamma
	% matrix. If neither add biase, write a '1' to the 'BeforeGrading.csv'.
	if (((d1 == 0) && (d2 == 0) && (sum(sum(g_diff)) == 0)) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    
    fclose(fid);
    
    
    
    fprintf('\n \n')
    cd gm/
    
    try
        clear
        clear global
        broke_indicater = 0;
        load gamma_test
        main
    catch e
        e.getReport()
        disp('broke in test gm')
        broke_indicater = 1;
    end
    
    cd ..
    fid = fopen('BeforeGrading.csv','a');
	%Check whether the program crashed in the test. If crashed, write a "1" 
    %to the 'BeforeGrading.csv'.
    if (broke_indicater == 1)
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
	%Check whether the loglikelihood is right. If wrong, write a "1" to the 
    %'BeforeGrading.csv'.
    if (ll ~= -Inf)
    	if ((abs(nll - (ll)) > error) || (broke_indicater == 1))
            fprintf(fid,[num2str(1) ',']);
        else
            fprintf(fid,[num2str(0) ',']);
        end
    else
        fprintf(fid,[num2str(1) ',']);
    end
	%Check whether the run time is too long. If too long, write a "1" to the 
    %'BeforeGrading.csv'.
	if ((etime(t2, t1) > 230) || (broke_indicater == 1))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);
    

    
    
    restoredefaultpath;
end


%Create a Grade Book. The weight could be changed.
fid=fopen('BeforeGrading.csv', 'rt');
title = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter', ',');
uni_score = textscan(fid, '%s %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32 %d32','delimiter', ',');
fclose(fid);

fid = fopen('Grade.csv','a');
for i = 1 : length(uni_score{1})
    grades = 100;
    grades = grades - uni_score{2}(i) * 0 - uni_score{3}(i) * 10 - uni_score{4}(i) * 5 - uni_score{5}(i) * 5 - uni_score{6}(i) * 5;
    grades = grades - uni_score{7}(i) * 0 - uni_score{8}(i) * 4 - uni_score{9}(i) * 2 - uni_score{10}(i) * 2 - uni_score{11}(i) * 2;
    grades = grades - uni_score{12}(i) * 0 - uni_score{13}(i) * 4 - uni_score{14}(i) * 3 - uni_score{15}(i) * 4 - uni_score{16}(i) * 4;
    grades = grades - uni_score{17}(i) * 0 - uni_score{18}(i) * 0 - uni_score{19}(i) * 8 - uni_score{20}(i) * 2;
    grades = grades - uni_score{21}(i) * 0 - uni_score{22}(i) * 2 - uni_score{23}(i) * 0 - uni_score{24}(i) * 2 - uni_score{25}(i) * 0 - uni_score{26}(i) * 2 - uni_score{27}(i) * 2 - uni_score{28}(i) * 25;
    grades = grades - uni_score{29}(i) * 0 - uni_score{30}(i) * 5 - uni_score{31}(i) * 2;
    fprintf(fid,[uni_score{1}{i} ',' num2str(grades) ',' '\n']);
end
fclose(fid);
