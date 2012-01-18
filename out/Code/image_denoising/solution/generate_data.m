% generate test data
function[] = generate_data

img = double(imread('professor_wood.bmp'));
img(img==0) = 1;
img(img==255) = -1;

noise = (rand(size(img))<.1)*3;
noisy_img = img;

noisy_img(2:end,2:end) = img(2:end,2:end) + noise(2:end,2:end);
noisy_img(noisy_img==4) =-1;
noisy_img(noisy_img==2) = 1;

save('data','img','noisy_img')