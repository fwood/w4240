function[clean_img] = denoise_alternative(noisy_img)
%Function to return a clearned img after being given a noisy image.  The
%method in which the clean img is obtained is up to you.  The function
%should work for any binary image.
%
%@param noisy_img   : a binary matrix representing a noisy image
%
%@param clean_img   : a binary matrix representing the cleaned version of
%                     the input noisy_img

%My potential solution is to perform something called Gibbs sampling and
%then take the average to find the pixel value.  After Gibbs sampling I
%pass it through the iterated conditional modes method a few times just to
%make sure I am at a local max in terms of the potential function of the
%configuration.

figure(1)
imagesc(noisy_img)
figure(2)

clean_img = noisy_img;

[h beta eta] = get_parameters();

loops = 100;
burn_in = 2;

for loop = 1 : loops
    for row = 1 : size(noisy_img,1)
        for col = 1 : size(noisy_img,2)
            [choice lp_minus_1 lp_plus_1] = local_potential(clean_img, noisy_img,row,col, h, beta, eta);
            p = lp_minus_1 / (lp_minus_1 + lp_plus_1);
            if rand() < p
                clean_img(row, col) = -1;
            else
                clean_img(row,col) = 1;
            end
        end
    end
    
    disp(['loop = ' num2str(loop)]);
    eval(['clean_img_', num2str(loop),' = clean_img;']);
    imagesc(clean_img)
    drawnow
end

summed_img = zeros(size(noisy_img));
eval(['summed_img = clean_img_' num2str(burn_in + 1) ';']);
for i = (burn_in + 2) : loops
    eval(['summed_img = summed_img + clean_img_' num2str(i) ';']);
end

clean_img = summed_img / (loops - burn_in);
clean_img(clean_img > 0) = 1;
clean_img(clean_img <= 0) = -1;

imagesc(clean_img)
drawnow

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