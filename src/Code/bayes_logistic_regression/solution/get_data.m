
function [X Y headers] = get_data()

fid = fopen('arthritis_treatment');
X = [];
Y = [];
line = ' ';
while 1
    line = fgetl(fid);
    if ~ischar(line) break; end
    A = textscan(line,'%n %s %s %n %n %n %s %s %n %n');
    
    if strcmp(A{2},'Treated')
        treated = 1;
    else 
        treated = 0;
    end
    
    if strcmp(A{3},'Male')
        male = 1;
    else
        male = 0;
    end
    
    X = [X ; treated male log(A{4})];
    Y = [Y ; (A{5} > 0)];
    
    if strcmp(A{7},'Treated')
        treated = 1;
    else 
        treated = 0;
    end
    
    if strcmp(A{8},'Male')
        male = 1;
    else
        male = 0;
    end
    
    X = [X ; treated male log(A{9})];
    Y = [Y ; (A{10} > 0)];
end

X = [X X(:,1).*X(:,2) X(:,1).*X(:,3) X(:,2).*X(:,3) X(:,1).*X(:,2).*X(:,3)];
X = [ones(size(X,1),1) X];
headers = {'intercept','treated','male','log age','treated x male', 'treated x log age', 'male x age', 'treated x male x log age'};

fclose(fid);