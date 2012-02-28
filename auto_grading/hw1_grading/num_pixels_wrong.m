function ret = num_pixels_wrong(src_img, restored_img)
disp('this is the real one!')
ret = sum(sum(src_img~=restored_img));