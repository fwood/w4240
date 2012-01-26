%uni_list = textread('uni_list.txt','%s');
uni_list = {'mra2110'};

%things I want to check
%1.)the denoise scaffold runs and gets an answer
%result: num_pixels_wrong and binary ran or not
%2.)check the local potentials are correctly calculated for some pixels
% yes or no, ran or did not run
%3.)check the alternative method
%result: num_pixels_wrong and binary ran or not

grades = {};
load data
for i = 1 : size(uni_list,1)
    restoredefaultpath
    
    grade = 50;
    
    [clean_img bug1] = denoise_check(uni_list{i});
    num_wrong = num_pixels_wrong(img, clean_img);
    
    if (num_wrong < 7000)   grade = grade + 20 ; end
    if (num_wrong < 1500)   grade = grade + 15 ; end
    if (num_wrong < 1000)   grade = grade + 5  ; end
    if (num_wrong < 900)    grade = grade + 5  ; end

    disp(num_wrong)
    num_wrong1 = num_wrong;
    
    restoredefaultpath
    
    [correct bug2] = local_potential_check(uni_list{i});
    if (correct) grade = grade + 5; end;
    
    restoredefaultpath
    
    [clean_img bug3] = denoise_alt_check(uni_list{i});
    num_wrong = num_pixels_wrong(img, clean_img);
    if (num_wrong < 17585)  grade = grade + 4  ; end
    if (num_wrong < 7000)   grade = grade + 2  ; end
    if (num_wrong < 1500)   grade = grade + 2  ; end
    if (num_wrong < 1000)   grade = grade + 1  ; end
    if (num_wrong < 900)    grade = grade + 1  ; end
    
    disp(num_wrong)
    num_wrong2 = num_wrong;
   
    grades{i} = {{grade, num_wrong1, num_wrong2}, {uni_list{i}, bug1, bug2, bug3}};
end
%%

%save('grades', 'grades')

clear
load grades

numeric_grades = zeros(42,1);
unis = cell(42,1);

for i = 1 : 42
    numeric_grades(i) = grades{i}{1}{1};
    unis{i} = grades{i}{2}{1};
end



fid = fopen('upload.csv','w');

fprintf(fid,['UNI,hw1' '\n' 'Total_points,100' '\n']);
for i = 1 : 42
    fprintf(fid,[unis{i} ',' num2str(numeric_grades(i))]);
    if i < 42
        fprintf(fid,'\n');
    end
end

fclose(fid);





