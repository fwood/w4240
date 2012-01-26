function grades = ruberic(numerical_results)

grades = zeros(size(numerical_results(:,1)));

% 80% based on result

num_wrong = numerical_results(:,1);

grades(num_wrong < 17585) = grades(num_wrong < 17585) + 50;
grades(num_wrong < 7000) = grades(num_wrong < 7000) + 10;
grades(num_wrong < 1500) = grades(num_wrong < 1500) + 10;
grades(num_wrong < 1000) = grades(num_wrong < 1000) + 5;
grades(num_wrong < 900) = grades(num_wrong < 900) + 5;

% 20% based on getting the local potentials correct

got_it = numerical_results(:,2);
grades(got_it == 1) = grades(got_it == 1) + 20;

%extra 10% based on alternative procedure

num_wrong = numerical_results(:,3);

grades(num_wrong < 17585) = grades(num_wrong < 17585) + 4;
grades(num_wrong < 7000) = grades(num_wrong < 7000) + 2;
grades(num_wrong < 1500) = grades(num_wrong < 1500) + 2;
grades(num_wrong < 1000) = grades(num_wrong < 1000) + 1;
grades(num_wrong < 900) = grades(num_wrong < 900) + 1;