function ret = num_pixels_wrong(src_img, restored_img)

ret = sum(sum(src_img~=restored_img));