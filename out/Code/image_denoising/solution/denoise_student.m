function[n_pixels_wrong] = denoise_student()
%Function which you can run to test your code. To execute this code you
%will first need to fill out the functions get_parameters_student and
%local_potential_student.  It will be necessary for you to undersand this
%code in order to know how to fill out those functions.
%
% @return n_pixels_wrong : the number of wrongly classified pixels

load data.mat
figure(1)
imagesc(img)
figure(2)
imagesc(noisy_img)

[h beta eta] = get_parameters_student();

clean_img = noisy_img;

figure(3)

loops = 5;

for l = 1:loops
    for row = 1 : size(noisy_img,1)
        for col = 1 : size(noisy_img,2)
            clean_img(row, col) = local_potential_student(clean_img, noisy_img,row,col,h,beta,eta);    
        end
    end
    disp(['loop = ' num2str(l)]);
    imagesc(clean_img)
    drawnow
end

n_pixels_wrong = num_pixels_wrong(img, clean_img);