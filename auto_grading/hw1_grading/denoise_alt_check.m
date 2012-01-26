function [clean_img bug] = denoise_alt_check(student)

disp(['working on student ' student]);

p = ['../hw1/' student];
addpath(p);

clear
load data.mat

clean_img = noisy_img;
bug = '';

try
    clean_img = denoise_student_alternative(noisy_img);
catch
    bug = 'denoise alt didnt work';
    return;
end