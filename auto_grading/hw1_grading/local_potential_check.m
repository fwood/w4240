function [correct bug] = local_potential_check(student);

p = ['../hw1/' student];
addpath(p);

clear
load data.mat

h = 1.2; beta = 2.3; eta = .2;

correct = 1;
bug = '';

i = 10; j = 20;
[c,l_n1,l_p1] = local_potential(noisy_img, noisy_img,i,j,h,beta,eta);
l_n1 = l_n1 / sum(l_n1 + l_p1);
l_p1 = l_p1 / sum(l_n1 + l_p1);
try
    [sc,sl_n1,sl_p1] = local_potential_student(noisy_img, noisy_img,i,j,h,beta,eta);
    sl_n1 = sl_n1 / sum(sl_n1 + sl_p1);
    sl_p1 = sl_p1 / sum(sl_n1 + sl_p1);
    
    if abs(sl_n1 - l_n1) >= .01 || abs(l_p1 - sl_p1) >= .01
        correct = 0;
    end
catch exception
    correct = 0;
    bug = 'local potential bombed out';
    return;
end

i = 1; j = 1;
[c,l_n1,l_p1] = local_potential(noisy_img, noisy_img,i,j,h,beta,eta);
l_n1 = l_n1 / sum(l_n1 + l_p1);
l_p1 = l_p1 / sum(l_n1 + l_p1);
try
    [sc,sl_n1,sl_p1] = local_potential_student(noisy_img, noisy_img,i,j,h,beta,eta);
    sl_n1 = sl_n1 / sum(sl_n1 + sl_p1);
    sl_p1 = sl_p1 / sum(sl_n1 + sl_p1);
    
    if abs(sl_n1 - l_n1) >= .01 || abs(l_p1 - sl_p1) >= .01
        correct = 0;
    end
catch exception
    correct = 0;
    bug = 'local potential bombed out';
    return;
end

i = 100; j = 201;
[c,l_n1,l_p1] = local_potential(noisy_img, noisy_img,i,j,h,beta,eta);
l_n1 = l_n1 / sum(l_n1 + l_p1);
l_p1 = l_p1 / sum(l_n1 + l_p1);
try
    [sc,sl_n1,sl_p1] = local_potential_student(noisy_img, noisy_img,i,j,h,beta,eta);
    sl_n1 = sl_n1 / sum(sl_n1 + sl_p1);
    sl_p1 = sl_p1 / sum(sl_n1 + sl_p1);
    
    if abs(sl_n1 - l_n1) >= .01 || abs(l_p1 - sl_p1) >= .01
        correct = 0;
    end
catch exception
    correct = 0;
    bug = 'local potential bombed out';
    return;
end

i = 101; j = 1;
[c,l_n1,l_p1] = local_potential(noisy_img, noisy_img,i,j,h,beta,eta);
l_n1 = l_n1 / sum(l_n1 + l_p1);
l_p1 = l_p1 / sum(l_n1 + l_p1);
try
    [sc,sl_n1,sl_p1] = local_potential_student(noisy_img, noisy_img,i,j,h,beta,eta);
    sl_n1 = sl_n1 / sum(sl_n1 + sl_p1);
    sl_p1 = sl_p1 / sum(sl_n1 + sl_p1);
    
    if abs(sl_n1 - l_n1) >= .01 || abs(l_p1 - sl_p1) >= .01
        correct = 0;
    end
catch exception
    correct = 0;
    bug = 'local potential bombed out';
    return;
end
    



