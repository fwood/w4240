% Set up a main file to do loopy belief propagation for the task of image
% denoising.  Use the markov random field model from the first homework,
% but perform inference using loopy belief propagation.  Create an image
% called clean_img which is a cleaned version of the noisy loaded image.  
% For convenience, the pixel values have been labeled as 1 or 2 to fit 
% into the code base you have developed for message passing.  You do not 
% need to fuss about convergence of the loopy beleif propagation, instead 
% you can just run 20 iterations of the outer loop and make sure that the 
% cleaned image looks reasonable.

set(0,'RecursionLimit',4000)

h = ?;
beta = ?;
eta = ?;

load image_data.mat

% insert logic here to create the appropriate factor graph and run loopy bp

clean_img = noisy_img;

% insert logic here to assign the value of noisy image based on the loopy
% bp

figure(1)
imagesc(noisy_img)

figure(2)
imagesc(clean_img)
