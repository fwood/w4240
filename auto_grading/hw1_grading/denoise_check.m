function [clean_img bug] = denoise_check(student)

disp(['working on student ' student]);

p = ['../hw1/' student];
addpath(p);

load data.mat
clean_img = noisy_img;

try
    [h beta eta] = get_parameters_student();
catch exception
    bug = 'get parameters didnt work';
    return;
end

loops = 10;
npw = num_pixels_wrong(clean_img, img);

bug = '';
for l = 1:loops
    for row = 1 : size(noisy_img,1)
        for col = 1 : size(noisy_img,2)
            try
                clean_img(row, col) = local_potential_student(clean_img, noisy_img, row, col, h, beta, eta);    
            catch exception
                bug = 'local potential bugged out somewhere';
                if col > 1 && col < size(noisy_img,2) && row > 1 && row < size(noisy_img,1)
                    return 
                end
            end
        end
    end

    disp(['loop = ' num2str(l)]);
    if (num_pixels_wrong(clean_img, img) >= npw)
        return;
    else
        npw = num_pixels_wrong(clean_img, img);
    end
end