restoredefaultpath;
clc

cd ~/Documents/ta/w4240/hw/hw3_grading

uni = 'dak2135';
p = ['~/Documents/ta/w4240/hw/hw3/' uni];
addpath(p);

% Linear regress answer
%
% log likelihood = -270.8895, alpha = 0.72357, beta = 9.7771
%
% second dataset
%
% log likelihood = -14094.0922, alpha = 10.1385, beta = 0.99904

cd lr/

fprintf('\n \n')

try
    clear
    clear global
    d = 15;
    load data_linear_regression
    main
catch e
    e.getReport()
    disp('broke in regular linear regress')
end

fprintf('\n \n')

try
    clear
    clear global
    d = 199;
    load data_test
    main
catch e
    e.getReport()
    disp('broke in test regress')
end

fprintf('\n \n')

try
    clear
    clear global
    load data_linear_regression
    check_e_m(X,Y);
catch e
    e.getReport()
    disp('broke in check regress')
end


cd ..

% Gaussian mixture answer
%
% for regular, k = 2
% the log likelihood = -278.8318
%
% for test k = 15
% the log likelihood = -150.2529

cd gm/

fprintf('\n \n')

try
    clear
    clear global
    load gamma
    main
catch e
    e.getReport()
    disp('broke in regular gm')
end

fprintf('\n \n')

try
    clear
    clear global
    load gamma_test
    main
catch e
    e.getReport()
    disp('broke in test gm')
end

fprintf('\n \n')

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
end

cd ..
