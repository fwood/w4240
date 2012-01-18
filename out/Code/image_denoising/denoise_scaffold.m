% image denoising scaffold code for homework, Iterated Conditional Means

load data.mat
figure(1)
imagesc(img)
figure(2)
imagesc(noisy_img)

h = ?;
beta = ?;
eta = ?;

clean_img = noisy_img;

figure(3)

max_loops = 10;

for l = 1:max_loops
    for r = 2:(size(noisy_img,1) -1)
        for c = 2:(size(noisy_img,2) -1)
            loc_pot_minus_1 = 
            loc_pot_plus_1 = 
            
            if loc_pot_minus_1 <= loc_pot_plus_1
                clean_img(r,c) = ?;
            else
                clean_img(r,c) = ?;
            end
        end
    end
    imagesc(clean_img)
    drawnow
    
end

disp([ 'Restoration: pixels wrong : ' num2str(num_pixels_wrong(img, clean_img)) '/' num2str(prod(size(img)))]);
