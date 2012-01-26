function[n_pixels_wrong] = denoise()

load data.mat
figure(1)
imagesc(img)
figure(2)
imagesc(noisy_img)

[h beta eta] = get_parameters();

clean_img = noisy_img;

figure(3)

loops = 5;

for l = 1:loops
    for row = 2 : (size(noisy_img,1)-1)
        for col = 2 : (size(noisy_img,2)-1)
            clean_img(row, col) = local_potential(clean_img, noisy_img,row,col,h,beta,eta);    
        end
    end
    disp(['loop = ' num2str(l)]);
    imagesc(clean_img)
    drawnow
end

n_pixels_wrong = num_pixels_wrong(img, clean_img);