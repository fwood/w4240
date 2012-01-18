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
    for row = 1 : size(noisy_img,1)
        for col = 1 : size(noisy_img,2)
            clean_img(row, col) = local_potential(clean_img, noisy_img,row,col,h,beta,eta);    
        end
    end
    disp(['loop = ' num2str(l)]);
    imagesc(clean_img)
    drawnow
end

disp(['the energy is ' num2str(total_energy(clean_img, noisy_img, h, beta, eta))])

n_pixels_wrong = num_pixels_wrong(img, clean_img);