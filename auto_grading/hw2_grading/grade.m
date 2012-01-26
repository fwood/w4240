%first answer is
% 0.0163 T
% 0.9837 F



cd ~/Documents/ta/w4240/hw/hw2_grading/
clc
clear
clear global

student = 'ss2857';

%problem 1;
restoredefaultpath;
p = ['../hw2/' student];
addpath(p);
p = 'explicit/';
addpath(p);

main_alarm_network
check_get_messages


%addpath('./solution/');
% 
%main_alarm_network



%%
%problem 2;

%second answer is 
% 0.0270 
% 0.9730 

clear
clear global
clc

student = 'ssz2105';

%%cd explicit/

restoredefaultpath;
p = ['../hw2/' student];
addpath(p);
p = 'object';
addpath(p);

%addpath('./solution/');

main_big_alarm_net




