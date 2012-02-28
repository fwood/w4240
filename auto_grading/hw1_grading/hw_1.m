% Modified by Gustavo Lacerda, 17 Feb 2012
%
% Theoretically maximum grade: 110
%
% Changes:
% * the grade is now recorded to the output file immediately after each run.
% * it checks the output file to see which students have been done already,
% thus avoiding doing the same work again.  If the grading code is modified
% substantially, we should delete the output file, so that the code runs everybody.
% * we removed the header from the output file: ['UNI,hw1' '\n'
% 'Total_points,100' '\n']
%
% REMARK (potential security hole): 3 out of 62 students submitted num_pixels_wrong.m.
% If they had modified this code, it might be possible to cheat this way.
% This depends on which version of the function is shadowing the other.


ids = dir('../hw1')
ids2 = struct2cell(ids)
ids3 = ids2(:)
ids4 = ids3(1:5:size(ids3,1))
ids5 = ids4(4:size(ids4,1))

%uni_list = textread('uni_list.txt','%s');
uni_list = ids5(:);

% removing from uni_list those students who are already done
fid=fopen('upload.csv', 'rt');
C = textscan(fid,'%s %f','Delimiter',',');
fclose(fid);
students_done = C{1};
uni_list = setdiff(uni_list, students_done)

disp(uni_list)


%things I want to check
%1.)the denoise scaffold runs and gets an answer
%result: num_pixels_wrong and binary ran or not
%2.)check the local potentials are correctly calculated for some pixels
% yes or no, ran or did not run
%3.)check the alternative method
%result: num_pixels_wrong and binary ran or not

numeric_grades = zeros(size(uni_list,1),1);
unis = cell(size(uni_list,1),1);


% initialize output file
%fid = fopen('upload.csv','w');
%fprintf(fid,['UNI,hw1' '\n' 'Total_points,100' '\n']);
%fclose(fid);


write_to_output_file = 0; %% ------ change this to 1 if running for real.

grades = {};
load data
for i = 1 : size(uni_list,1)
    restoredefaultpath % forget previous student
    
    grade = 50; % initialize grade to 50

    % Denoise check %%%%%%%%%%%%%
    
    [clean_img bug1] = denoise_check(uni_list{i}); % calls get_parameters_student, local_potential_student
    num_wrong = num_pixels_wrong(img, clean_img);
    
    if (num_wrong < 7000)   grade = grade + 20 ; end
    if (num_wrong < 1500)   grade = grade + 15 ; end
    if (num_wrong < 1000)   grade = grade + 5  ; end
    if (num_wrong < 900)    grade = grade + 5  ; end

    disp(num_wrong)
    num_wrong1 = num_wrong;
    
    restoredefaultpath
    
    % Local Potential Check %%%%%
    
    [correct bug2] = local_potential_check(uni_list{i}); %calls local_potential_student
    if (correct) grade = grade + 5; end;
    
    restoredefaultpath
    
    % Denoise Alt Check %%%%%%%%%
    
    [clean_img bug3] = denoise_alt_check(uni_list{i}); %calls denoise_student_alternative
    num_wrong = num_pixels_wrong(img, clean_img);
    if (num_wrong < 17585)  grade = grade + 4  ; end
    if (num_wrong < 7000)   grade = grade + 2  ; end
    if (num_wrong < 1500)   grade = grade + 2  ; end
    if (num_wrong < 1000)   grade = grade + 1  ; end
    if (num_wrong < 900)    grade = grade + 1  ; end
    
    disp(num_wrong)
    num_wrong2 = num_wrong;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    grades{i} = {{grade, num_wrong1, num_wrong2}, {uni_list{i}, bug1, bug2, bug3}};            
    numeric_grades(i) = grades{i}{1}{1};
    unis{i} = grades{i}{2}{1};
    
    if (write_to_output_file)    % append this student's UNI and grade to the output file
        fid = fopen('upload.csv','a');
        fprintf(fid,[unis{i} ',' num2str(numeric_grades(i))]);
        if i < size(uni_list,1)
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
    
end


save('grades', 'grades')





