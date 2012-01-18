function [choice loc_pot_minus_1, loc_pot_plus_1] = local_potential_student(clean_img, noisy_img, row, column, h, beta, eta)
%The logic here must compute the local contribution to the potential
%function for the possible pixel values of -1 and 1 and make a choice
%regarding which pixel to choose (-1 or +1).  The potential function values
%you return need not be normalized.
%
%@param clean_img   : the current, cleanest,version of the image
%@param noisy_img   : the original noisy image
%@param row         : the row of the pixel under inspection
%@param col         : the column of the pixel under inspection
%@param h           : the h parameter of the procedure
%@param beta        : the beta parameter of the procedure
%@param eta         : the eta parameter of the procedure
%
%returns [choice loc_pot_minus_1 loc_pot_plus_1]
%
%@return choice         : the new value of the pixel under inspection (-1 or 1)
%@return loc_pot_minus_1: the local potential associated with a choice of
%                         -1, does not need to be normalized.
%@return loc_pot_plus_1 : the local potential associated with a choice of 1,
%                         does not need to be normalized.