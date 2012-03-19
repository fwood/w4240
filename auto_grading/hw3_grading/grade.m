clc;
Path_of_Student_HW = 'D:\Backup\My Document\MATLAB\Documents\ta\w4240\hw\hw3\';
Path_of_The_Grading_Program = 'D:\Backup\My Document\MATLAB\Documents\ta\w4240\hw\hw3_grading\';
Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW = 0;

ids = dir(Path_of_Student_HW); ids2 = struct2cell(ids); ids3 = ids2(:); ids4 = ids3(1:5:size(ids3,1));
ids5 = ids4(3:size(ids4,1)); ids6 = ids5(1:(size(ids5)-Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW),1);
uni_list = ids6(:);Path_of_BeforeGrading_File = [Path_of_The_Grading_Program 'BeforeGrading.csv'];

fid = fopen(Path_of_BeforeGrading_File,'a');
fclose(fid);

for i = 1 : size(uni_list,1)
    Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW = 0;
    Path_of_Student_HW = 'D:\Backup\My Document\MATLAB\Documents\ta\w4240\hw\hw3\';
    Path_of_The_Grading_Program = 'D:\Backup\My Document\MATLAB\Documents\ta\w4240\hw\hw3_grading\';

    ids = dir(Path_of_Student_HW);
    ids2 = struct2cell(ids);
    ids3 = ids2(:);
    ids4 = ids3(1:5:size(ids3,1));
    ids5 = ids4(3:size(ids4,1));
    ids6 = ids5(1:(size(ids5)-Number_of_Files_Not_Given_By_Students_in_Path_of_Student_HW),1);
    uni_list = ids6(:);
    Path_of_BeforeGrading_File = [Path_of_The_Grading_Program 'BeforeGrading.csv'];
    Path_of_Trial_File = [Path_of_The_Grading_Program 'Trial.txt'];
    
    fid=fopen(Path_of_BeforeGrading_File, 'rt');
    C = textscan(fid,'%s %f','Delimiter',',');
    fclose(fid);
    students_done = C{1};
    uni_list = setdiff(uni_list, students_done);
    disp(uni_list)

    restoredefaultpath;

    cd (Path_of_The_Grading_Program)

    uni = uni_list{1};
    p = [Path_of_Student_HW uni '\'];
    addpath(p);
    
    fid = fopen('BeforeGrading.csv','a');
    fprintf(fid,[uni_list{1} ',']);
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
    trial = fopen('trial.txt','w');
    fprintf(trial,'True');
    fclose(trial);
    try
        clear
        clear global
        d = 15;
        load data_linear_regression
        main
    catch e
        e.getReport()
        disp('broke in regular linear regress')
        trial = fopen('trial.txt','w');
        fprintf(trial,'broke_in_regular_linear_regress');
        fclose(trial);
    end

    trial = fopen('trial.txt','r');
    Token = textscan(trial,'%s %f','Delimiter',',');
    fclose(trial);
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    if (strcmp(Token{1}{1}, 'broke_in_regular_linear_regress'))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);
    
    
    fprintf('\n \n')
	cd lr/
    trial = fopen('trial.txt','w');
    fprintf(trial,'True');
    fclose(trial);
    try
        clear
        clear global
        d = 199;
        load data_test
        main
    catch e
        e.getReport()
        disp('broke in test regress')
        trial = fopen('trial.txt','w');
        fprintf(trial,'broke in test regress');
        fclose(trial);
    end
    
    trial = fopen('trial.txt','r');
    Token = textscan(trial,'%s %f','Delimiter',',');
    fclose(trial);
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    if (strcmp(Token{1}{1}, 'broke in test regress'))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);

    
    fprintf('\n \n')
	cd lr/
    trial = fopen('trial.txt','w');
    fprintf(trial,'True');
    fclose(trial);
    try
        clear
        clear global
        load data_linear_regression
        check_e_m(X,Y);
    catch e
        e.getReport()
        disp('broke in check regress')
        trial = fopen('trial.txt','w');
        fprintf(trial,'broke in check regress');
        fclose(trial);
    end
    
    trial = fopen('trial.txt','r');
    Token = textscan(trial,'%s %f','Delimiter',',');
    fclose(trial);
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    if (strcmp(Token{1}{1}, 'broke in check regress'))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);


    % Gaussian mixture answer
    %
    % for regular, k = 2
    % the log likelihood = -278.8318
    %
    % for test k = 15
    % the log likelihood = -150.2529

    fprintf('\n \n')
    cd gm/
    trial = fopen('trial.txt','w');
    fprintf(trial,'True');
    fclose(trial);
    
    try
        clear
        clear global
        load gamma
        main
    catch e
        e.getReport()
        disp('broke in regular gm')
        trial = fopen('trial.txt','w');
        fprintf(trial,'broke in regular gm');
        fclose(trial);
    end
    
	trial = fopen('trial.txt','r');
    Token = textscan(trial,'%s %f','Delimiter',',');
    fclose(trial);
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    if (strcmp(Token{1}{1}, 'broke in regular gm'))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);
    

    fprintf('\n \n')
    cd gm/
    trial = fopen('trial.txt','w');
    fprintf(trial,'True');
    fclose(trial);

    try
        clear
        clear global
        load gamma_test
        main
    catch e
        e.getReport()
        disp('broke in test gm')
        trial = fopen('trial.txt','w');
        fprintf(trial,'broke in test gm');
        fclose(trial);
    end
    
	trial = fopen('trial.txt','r');
    Token = textscan(trial,'%s %f','Delimiter',',');
    fclose(trial);
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    if (strcmp(Token{1}{1}, 'broke in test gm'))
        fprintf(fid,[num2str(1) ',']);
    else
        fprintf(fid,[num2str(0) ',']);
    end
    fclose(fid);
    

    fprintf('\n \n')
    cd gm/
    trial = fopen('trial.txt','w');
    fprintf(trial,'True');
    fclose(trial);

    try
        clear
        clear global
        load gamma
        load fisheriris
        data = meas;
    
        check_e_m(data,gamma)
    catch e
        e.getReport()
        disp('broke in check gm')
        trial = fopen('trial.txt','w');
        fprintf(trial,'broke in check gm');
        fclose(trial);
    end
    
    trial = fopen('trial.txt','r');
    Token = textscan(trial,'%s %f','Delimiter',',');
    fclose(trial);
    cd ..
    fid = fopen('BeforeGrading.csv','a');
    if (strcmp(Token{1}{1}, 'broke in check gm'))
        fprintf(fid,[num2str(1) ',' '\n']);
    else
        fprintf(fid,[num2str(0) ',' '\n']);
    end
    fclose(fid);

    cd ..

end